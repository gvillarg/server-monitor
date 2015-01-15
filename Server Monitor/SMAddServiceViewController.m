//
//  SMAddServiceViewController.m
//  Server Monitor
//
//  Created by Cesar on 10/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

NSString *pw = @"Página Web";
NSString *sw = @"Servicio Web";
NSString *ftp = @"Servicio FTP";

#import "SMAddServiceViewController.h"
#import "SMOServiceAccess.h"
#import "SMOServiceIP.h"
#import "SMPopUpUrlServices.h"
#import <netdb.h>
#include <arpa/inet.h>
#import "AFHTTPRequestOperation.h"

@interface SMAddServiceViewController () <UITextFieldDelegate>

@end

@implementation SMAddServiceViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.url becomeFirstResponder];
    type_array = [[NSMutableArray alloc] init];
    [type_array addObject:pw];
    [type_array addObject:sw];
    [type_array addObject:ftp];
    _url.delegate = self;
    _type.delegate = self;
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    pickerTypeView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    _type.text = [type_array objectAtIndex:0];
    _type.inputView = pickerTypeView;
    pickerTypeView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_type resignFirstResponder];
    [_url resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _url) {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	if (textField == self.url) {
		[self.url resignFirstResponder];
		[self save:self];
	}
	return YES;
}

#pragma mark - Get Ip

- (NSMutableArray *)lookupHostIPAddress:(NSString *)strHostName
{
    Boolean result;
    _urlResult = [[NSMutableArray alloc] init];
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    char *hostname = (char *)[strHostName UTF8String];
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, hostname, kCFStringEncodingASCII);
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL); // pass an error instead of NULL here to find out why it failed
        if (result == TRUE) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    if (result == TRUE) {
        struct sockaddr_in*     remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++)
        {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL)
            {
                // Extract the ip address
                [_urlResult addObject: [NSString stringWithUTF8String:inet_ntoa(remoteAddr->sin_addr)]];
            }
        }
        NSLog(@"Resolved");
    } else {
        NSLog(@"Not resolved");
    }
    
    // Clean Up
    CFRelease(hostNameRef);
    CFRelease(hostRef);
    
    return _urlResult;
}


#pragma mark - Actions

- (IBAction)save:(id)sender {
    
    // Validate selected URL
    if (selectedURL.count == 0) {
        [self lookupHostIPAddress:self.url.text];
        SMPopUpUrlServices *alert = [[SMPopUpUrlServices alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
        alert.delegate = self;
        [self.view addSubview:alert];
        [alert show:_urlResult];
        return;
    }
    
    // Set serviceAccess
    SMOServiceAccess *serviceAccess;
    serviceAccess = [NSEntityDescription insertNewObjectForEntityForName:@"SMOServiceAccess" inManagedObjectContext:self.service.managedObjectContext];
    serviceAccess.url = self.url.text;
    self.service.serviceAccess = serviceAccess;
    serviceAccess.service = self.service;
    
    // Set service
    self.service.active = [NSNumber numberWithBool:false];
    if ([_type.text isEqualToString:pw]) {
        self.service.type = [SMOService webPage];
    }else if ([_type.text isEqualToString:sw]){
        self.service.type = [SMOService webService];
    }else{
        self.service.type = [SMOService ftpService];
    }
    
    // Set service IPs
    SMOServiceIP *ipService;
    self.service.serviceIP = [[NSMutableArray alloc] init];
    for (int i = 0; i < [selectedURL count]; i++) {
        ipService = [NSEntityDescription insertNewObjectForEntityForName:@"SMOServiceIP" inManagedObjectContext:self.service.managedObjectContext];
        ipService.addressIp = selectedURL[i];
        ipService.service = self.service;
        [self.service.serviceIP addObject: ipService];
    }
    
    //self.service.url = _urlResult[0];
    
//	NSError *error = nil;
    
    
    [self saveService];
    
//	if (![self.service.managedObjectContext save:&error]) {
//		/*
//		 Replace this implementation with code to handle the error appropriately.
//		 
//		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//		 */
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		abort();
//    }
    
}

- (void) saveService {
    // Start web service
    NSString *URLString = [NSString stringWithFormat:@"%@/service", URL_STRING];
    
    NSDictionary *params = [self.service toJson];
    NSLog(@"%@", params);
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:params error:nil];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"%@", responseObject);
        self.service.idservice = responseObject[@"idservice"];
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
    
    NSString *URLString = [NSString stringWithFormat:@"%@/serviceaccess", URL_STRING];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:params error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"%@", responseObject);
        [self saveServiceIPs];
        
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

- (void) saveServiceIPs
{
    // Start web service
    NSMutableArray *mutableOperations = [NSMutableArray array];
    for (SMOServiceIP *serviceIP in self.service.serviceIP) {
        // Set operation
        NSDictionary *params = [serviceIP toJson];
        NSLog(@"%@", params);
        
        NSString *URLString = [NSString stringWithFormat:@"%@/serviceterminal", URL_STRING];
        NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:params error:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
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
        
        // Add operation
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"%li of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations in batch complete");
        // Dismiss this view and display the Main view
        [self.delegate SMAddServiceDelegate:self didAddService: self.service];
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
    // End web service
}

- (IBAction)cancel:(id)sender {
	
	[self.service.managedObjectContext deleteObject:self.service];
    
	NSError *error = nil;
	if (![self.service.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self.delegate SMAddServiceDelegate:self didAddService:nil];
}

- (IBAction)showIP:(id)sender {
    NSString *url = self.url.text;
    NSString *str = url;
    if (![_type.text isEqualToString:ftp]) {
        str = [[url componentsSeparatedByString:@"/"] objectAtIndex:2];
    }
    [self lookupHostIPAddress:str];
    SMPopUpUrlServices *alert = [[SMPopUpUrlServices alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
    alert.delegate = self;
    [self.view addSubview:alert];
    [alert show:_urlResult];
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [type_array count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [type_array objectAtIndex: row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _type.text = [type_array objectAtIndex:row];
    
}


#pragma mark - Delegate

- (void)setUrlList:(NSMutableArray *)url{
    selectedURL = url;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
