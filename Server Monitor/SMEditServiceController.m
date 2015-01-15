				//
//  SMEditServiceController.m
//  Server Monitor
//
//  Created by Cesar Otoya on 7/22/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

NSString *pagew = @"Página Web";
NSString *servicew = @"Servicio Web";
NSString *serviceftp = @"Servicio FTP";

#import "SMEditServiceController.h"
#import "SMOServiceAccess.h"
#import "SMGetService.h"
#import "AFNetworking.h"
#import "SMViewServiceTableViewController.h"

NSString *seg = @"Segundos";
NSString *min = @"Minutos";
NSString *hr = @"Horas";
NSString *dy = @"Días";

@implementation SMEditServiceController

@synthesize service=_service;
@synthesize delegate=_delegate;
@synthesize type_text = _type_text;
@synthesize periodicityUnit = _periodicityUnit;
@synthesize managedObjectContext = __managedObjectContext;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    if (textField == _periodicityUnit) {
        pickerPeriod = [[UIPickerView alloc] initWithFrame:pickerFrame];
        _periodicityUnit.text = [period_array objectAtIndex:0];
        _periodicityUnit.inputView = pickerPeriod;
        pickerPeriod.delegate = self;
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _type_text) {
        if ([textField.text isEqualToString: pagew]) {
            _label6.text = @"Librerías";
            _label7.text = @"Parseo";
            _pwLibrary.hidden = false;
            _pwParse.hidden = false;
            _swMode.hidden = true;
            _recusive.hidden = true;
        }else if ([textField.text isEqualToString: serviceftp]){
            _label6.text = @"Modo";
            _label7.text = @"";
            _swMode.hidden = false;
            _pwLibrary.hidden = true;
            _pwParse.hidden = true;
            _recusive.hidden = true;
        }else{
            _label6.text = @"Recursivo";
            _label7.text = @"";
            _recusive.hidden = false;
            _swMode.hidden = true;
            _pwLibrary.hidden = true;
            _pwParse.hidden = true;
        }
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_type_text resignFirstResponder];
    [_periodicityUnit resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - General

-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (_service) {
        [_type_text setEnabled:false];
        _name.text = _service.name;
        
        if ([_service.type isEqualToString: [SMOService webService]]) {
            [_type_text setText:servicew];
            _label6.text = @"Modo";
            _label7.text = @"";
            _swMode.hidden = false;
            _pwLibrary.hidden = true;
            _pwParse.hidden = true;
            _recusive.hidden = true;
        }else if ([_service.type isEqualToString: [SMOService webPage]]){
            [_type_text setText:pagew];
            _label6.text = @"Librerías";
            _label7.text = @"Parseo";
            _pwLibrary.hidden = false;
            _pwParse.hidden = false;
            _swMode.hidden = true;
            _recusive.hidden = true;
        }else{
            [_type_text setText:serviceftp];
            _label6.text = @"Recursivo";
            _label7.text = @"";
            _recusive.hidden = false;
            _swMode.hidden = true;
            _pwLibrary.hidden = true;
            _pwParse.hidden = true;
        }
        _user.text = _service.serviceAccess.user;
        _password.text = _service.serviceAccess.password;
        [_security  setOn:[_service.serviceAccess.security boolValue] animated:true];
        [_activeSwitch setOn:[_service.active boolValue]];
        [_changeSimilarity setValue: [_service.similarity floatValue]];
        _url.text = _service.serviceAccess.url;
        _port.text = [_service.serviceAccess.port stringValue];
        [_similarity setText:[NSString stringWithFormat:@"%@%%", _service.similarity]];
        [self convertPeriod: [_service.periodicity integerValue]];
        
        //_port.text = [NSString stringWithFormat:@"%@", _service.];
    }
    
    _type_text.delegate = self;
    
    period_array = [[NSMutableArray alloc] init];
    [period_array addObject:seg];
    [period_array addObject:min];
    [period_array addObject:hr];
    [period_array addObject:dy];
    
    _periodicityUnit.delegate = self;
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"guardando valor y yendo a la vista principal");
        [self saveData];
        [self saveService];
        //guarda en db
//        NSError *error = nil;
//        if(![self.managedObjectContext save:&error]){
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//			abort();
//        };
    }
}

- (void) saveService {
    // Start web service
    NSString *URLString = [NSString stringWithFormat:@"%@/service/%@", URL_STRING, self.service.idservice];
    
    NSDictionary *params = [self.service toJson];
    NSLog(@"%@", params);
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:params error:nil];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"%@", responseObject);
        [self saveServiceAccess];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"¡Ups! Ha ocurrido un error."
                                  message: @"La dirección no se encuentra disponible"
                                  delegate: nil
                                  cancelButtonTitle: @"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
    }];
    
    [operation start];
    // End web service
}

- (void) saveServiceAccess {
    
    // Start web service
    NSDictionary *params = [self.service.serviceAccess toJson];
    NSLog(@"%@", params);
    
    NSString *URLString = [NSString stringWithFormat:@"%@/serviceaccess/%@", URL_STRING, self.service.idservice];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:params error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"%@", responseObject);
        [self.delegate addItemViewController:self servicio:_service];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"¡Ups! Ha ocurrido un error."
                                  message: @"La dirección no se encuentra disponible"
                                  delegate: nil
                                  cancelButtonTitle: @"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
    }];
    
    [operation start];
    // End web service
}

- (void)saveData
{
    _service.name = _name.text;
    //service.url = _url.text;
    _service.serviceAccess.url = _url.text;
    _service.serviceAccess.security = [NSNumber numberWithBool:_security.on];
    _service.serviceAccess.port = [NSNumber numberWithInteger:[_port.text integerValue]];
    _service.serviceAccess.user = _user.text;
    _service.serviceAccess.password = _password.text;
    _service.active = [NSNumber numberWithBool:_activeSwitch.on];
    _service.similarity = [NSNumber numberWithInteger:[_similarity.text integerValue]];
    _service.periodicity = [NSNumber numberWithInteger:[self convertPeriod]];
    if([_type_text.text isEqualToString:pagew]){
        _service.type = [SMOService webPage];
        _service.pwLibraries = [NSNumber numberWithBool:_pwLibrary.on ];
        _service.pwParser = [NSNumber numberWithBool:_pwParse.on];
    }else if([_type_text.text isEqualToString: servicew]){
        _service.type =  [SMOService webService];
    }else{
        _service.type = [SMOService ftpService];
        _service.stRecursive = [NSNumber numberWithBool:_recusive.on];
    }
}

- (IBAction)save:(id)sender;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"¿Desea Guardar?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Sí", nil];
    [alertView show];
}

- (IBAction)switchSC:(id)sender {
    if (_segmentedController.selectedSegmentIndex == 0) {
        _label1.text = @"Nombre";
        _label2.text = @"Tipo";
        _label3.text = @"Activo";
        _label4.text = @"Similitud";
        _label5.text = @"Periodo";
        _name.hidden = false;
        _activeSwitch.hidden = false;
        _similarity.hidden = false;
        _changeSimilarity.hidden = false;
        _type_text.hidden = false;
        _url.hidden = true;
        _port.hidden = true;
        _ping.hidden = true;
        _security.hidden = true;
        _password.hidden = true;
        _user.hidden = true;
        _separatorLine.hidden = false;
        if ([_type_text.text isEqualToString: pagew]) {
            _label6.text = @"Librerías";
            _label7.text = @"Parseo";
            _pwLibrary.hidden = false;
            _pwParse.hidden = false;
            _swMode.hidden = true;
            _recusive.hidden = true;
        }else if ([_type_text.text isEqualToString: servicew]){
            _label6.text = @"Modo";
            _label7.text = @"";
            _swMode.hidden = false;
            _pwLibrary.hidden = true;
            _pwParse.hidden = true;
            _recusive.hidden = true;
        }else if ([_type_text.text isEqualToString: serviceftp]){
            _label6.text = @"Recursivo";
            _label7.text = @"";
            _recusive.hidden = false;
            _swMode.hidden = true;
            _pwLibrary.hidden = true;
            _pwParse.hidden = true;
        }
        _periodicityNumber.hidden = false;
        _periodicityUnit.hidden = false;
    } else
    {
        _label1.text = @"URL";
        _label2.text = @"Puerto";
        _label3.text = @"SSL";
        _label4.text = @"";
        _label5.text = @"";
        _label6.text = @"";
        _label7.text = @"";
        _name.hidden = true;
        _type_text.hidden = true;
        _activeSwitch.hidden = true;
        _similarity.hidden = true;
        _changeSimilarity.hidden = true;
        _url.hidden = false;
        _port.hidden = false;
        _ping.hidden = false;
        _security.hidden = false;
        if (_security.on) {
            _label4.text = @"Usuario";
            _label5.text = @"Clave";
            _password.hidden = false;
            _user.hidden = false;
        }
        _separatorLine.hidden = true;
        _label6.text = @"";
        _label7.text = @"";
        _pwLibrary.hidden = true;
        _pwParse.hidden = true;
        _swMode.hidden = true;
        _recusive.hidden = true;
        _periodicityNumber.hidden = true;
        _periodicityUnit.hidden = true;
    }
}

- (IBAction)switchSecurity:(id)sender {
    if (_security.on) {
        _label4.text = @"Usuario";
        _label5.text = @"Clave";
        _password.hidden = false;
        _user.hidden = false;
    }else
    {
        _label4.text = @"";
        _label5.text = @"";
        _password.hidden = true;
        _user.hidden = true;
    }
}


- (IBAction)changeSimilarity:(UIStepper *)sender {
    sender.maximumValue = 100;
    sender.minimumValue = 0;
    double value = [sender value];
    [_similarity setText:[NSString stringWithFormat:@"%d%%", (int)value]];
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [period_array count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
        return [period_array objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _periodicityUnit.text = [period_array objectAtIndex:row];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navController = segue.destinationViewController;
    SMViewServiceTableViewController *viewService = (SMViewServiceTableViewController *)navController.topViewController;
    viewService.delegate = self;  // do didAddRecipe delegate method is called when cancel or save are tapped
    viewService.service = self.service;
}


#pragma mark - Ping Button

-(IBAction)pingProve:(id)sender
{
    if ([_service.type isEqualToString: [SMOService webService]]) {
       
    }else if ([_service.type isEqualToString: [SMOService webPage]]){
        
    }else{
        
    }


}

#pragma delegate

- (void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveDictionary:(NSDictionary *)data{
    SMOBaseService *servicioBase = [NSEntityDescription insertNewObjectForEntityForName:@"SMOBaseService" inManagedObjectContext:self.service.managedObjectContext];
    servicioBase.baseService = data;
    servicioBase.refreshDate = [NSDate date];
    [self.service addBaseServiceObject:servicioBase];
    NSError *error = nil;
    if (![self.service.managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Util

-(NSInteger)convertPeriod{
    NSInteger quantity = [_periodicityNumber.text integerValue];
    if([_periodicityUnit.text isEqualToString:seg]){
        return quantity;
    }else if ([_periodicityUnit.text isEqualToString:min]){
        return quantity*60;
    }else if ([_periodicityUnit.text isEqualToString:hr]){
        return quantity*1800;
    }else{
        return quantity*43200;
    }
}

-(void)convertPeriod:(NSInteger)quantity{
    if (quantity/43200 >= 1) {
        if (quantity%43200 == 0) {
            _periodicityUnit.text = dy;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity/43200)];
        }else if (quantity%1800 == 0){
            _periodicityUnit.text = hr;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity/1800)];
        }else if (quantity%60 == 0){
            _periodicityUnit.text = min;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity/60)];
        }else{
            _periodicityUnit.text = seg;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity)];
        }
    }else if (quantity/1800 >= 1){
        if (quantity%1800 == 0){
            _periodicityUnit.text = hr;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity/1800)];
        }else if (quantity%60 == 0){
            _periodicityUnit.text = min;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity/60)];
        }else{
            _periodicityUnit.text = seg;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity)];
        }
    }else if (quantity/60 >= 1){
        if (quantity%60 == 0){
            _periodicityUnit.text = min;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity/60)];
        }else{
            _periodicityUnit.text = seg;
            _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity)];
        }
    }else{
        _periodicityUnit.text = seg;
        _periodicityNumber.text = [NSString stringWithFormat:@"%d", (quantity)];
    }
}

@end
