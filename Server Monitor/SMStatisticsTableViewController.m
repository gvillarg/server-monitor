//
//  SMStatisticsTableViewController.m
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMStatisticsTableViewController.h"
#import "SMServicesIPTableViewController.h"
#import <Foundation/Foundation.h>
#import "SMOService.h"
#import "SMContext.h"
#import "AFNetworking.h"


@interface SMStatisticsTableViewController ()
    @property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation SMStatisticsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadServices];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Services
-(void) loadServices {
    
    NSString *string = [NSString stringWithFormat:@"%@/service?iduser=%@", URL_STRING, [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *responseObject) {
        
        NSLog(@"%@", responseObject);
        self.services = [SMOService parseArray:responseObject];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"¡Ups! Ha ocurrido un error."
                                  message: @"La dirección no se encuentra disponible"
                                  delegate: nil
                                  cancelButtonTitle: @"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
    }];
    
    [operation start];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]);
    
}
- (void)setServices:(NSMutableArray *)services {
    _sections = [[NSMutableArray alloc] init];
    
    for (SMOService *service in services) {
        NSDictionary *section = [self sectionForService:service];
        if (section == nil) {
            NSString *sectionTitle = service.type;
            NSMutableArray *sectionServices = [[NSMutableArray alloc] init];
            section = [[NSDictionary alloc] initWithObjectsAndKeys:sectionTitle, @"type", sectionServices, @"services", nil];
            [self.sections addObject:section];
        }
        NSMutableArray *sectionServices = section[@"services"];
        [sectionServices addObject:service];
    }
    
    [self.tableView reloadData];
}
- (NSDictionary *)sectionForService:(SMOService *)service{
    for (NSDictionary *section in self.sections) {
        if ([service.type isEqualToString:section[@"type"]]) {
            return section;
        }
    }
    return nil;
}
- (NSDictionary *)sectionForIndex:(NSIndexPath *)indexPath{
    return (NSDictionary *)self.sections[indexPath.section];
}
- (SMOService *)serviceFor:(NSIndexPath *)indexPath{
    NSMutableArray *sectionServices = [self sectionForIndex:indexPath][@"services"];
    return sectionServices[indexPath.row];
}

#pragma mark - Add Service Delegate

- (void)SMAddServiceDelegate:(SMAddServiceViewController *)addServiceController didAddService:(SMOService *)service
{
    if (service) {
        // show the recipe in the RecipeDetailViewController
        [self performSegueWithIdentifier:@"editService" sender:service];
    }
    
    // dismiss the RecipeAddViewController
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *sectionDictionary = self.sections[section];
    NSMutableArray *sectionServices = sectionDictionary[@"services"];
    return sectionServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"Cell";
    
    UITableViewCell *serviceCell =
    (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:serviceCell atIndexPath:indexPath];
    
    return serviceCell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    SMOService *service = [self serviceFor:indexPath];
    [cell.textLabel setText:service.name];
}
- (void)addItemViewController:(SMEditServiceController *)controller
{
//    [self.tableView reloadData];
    [self viewWillAppear:TRUE];
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        /* DELETE */
        [self deleteServiceAt:indexPath];
    }
}

- (void) deleteServiceAt:(NSIndexPath *)indexPath {
    // Start web service
    NSMutableArray *services = [self sectionForIndex:indexPath][@"services"];
    SMOService *service = [self serviceFor:indexPath];
    NSString *URLString = [NSString stringWithFormat:@"%@/service/%@", URL_STRING, service.idservice];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:URLString parameters:nil error:nil];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"%@", responseObject);
        [services removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionDictionary = self.sections[section];
    NSString *sectionType = sectionDictionary[@"type"];
    
    
    if ([sectionType isEqualToString: [SMOService webPage]]) {
        return @"Página Web";
    }else if([sectionType isEqualToString: [SMOService webService]]){
        return @"Servicio Web";
    }else if([sectionType isEqualToString: [SMOService ftpService]]){
        return @"Servicio FTP";
    }
    return sectionType;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SMOService *service = [self serviceFor:indexPath];
        
    SMServicesIPTableViewController *tit = (SMServicesIPTableViewController *)segue.destinationViewController;
    tit.managedObjectContext = self.managedObjectContext;
    tit.service = service;
}


@end
