//
//  SMServicesTableViewController.m
//  Server Monitor
//
//  Created by Cesar on 8/23/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMServicesTableViewController.h"
#import "SMOService.h"
#import "SMServiceTableViewCell.h"
#import "SMReviewCenter.h"
#import "SMWebService.h"
#import "AFNetworking.h"


@interface SMServicesTableViewController ()
    @property (nonatomic, strong) NSMutableArray *services;
@end

@implementation SMServicesTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize reviewCenter;
//@synthesize services = _services;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editButtonItem.title = @"Editar";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set the table view's row height
    self.tableView.rowHeight = 44.0;
//	NSError *error = nil;
//	if (![[self fetchedResultsController] performFetch:&error]) {
//		/*
//		 Replace this implementation with code to handle the error appropriately.
//		 
//		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//		 */
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		abort();
//	}
    
    reviewCenter = [[SMReviewCenter alloc] init];
    [self loadServices];
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
        [self setServices:[SMOService parseArray:responseObject]];
        

        
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
    _services = [[NSMutableArray alloc] init];
    
    for (SMOService *service in services) {
        NSDictionary *section = [self serviceSectionFor:service];
        if (section == nil) {
            section = [self newSectionFor:service];
        }
        NSMutableArray *sectionServices = section[@"services"];
        [sectionServices addObject:service];
    }

    [self.tableView reloadData];
}
- (NSDictionary *)serviceSectionFor:(SMOService *)service{
    for (NSDictionary *section in self.services) {
        if ([service.type isEqualToString:section[@"type"]]) {
            return section;
        }
    }
    return nil;
}
- (NSDictionary *)serviceSectionForIndex:(NSIndexPath *)indexPath{
    return (NSDictionary *)self.services[indexPath.section];
}
- (SMOService *)serviceFor:(NSIndexPath *)indexPath{
    NSMutableArray *sectionServices = [self serviceSectionForIndex:indexPath][@"services"];
    return sectionServices[indexPath.row];
}
- (NSDictionary *)newSectionFor:(SMOService *)service {
    NSString *sectionTitle = service.type;
    NSMutableArray *sectionServices = [[NSMutableArray alloc] init];
    NSDictionary *section = [[NSDictionary alloc] initWithObjectsAndKeys:sectionTitle, @"type", sectionServices, @"services", nil];
        [self.services addObject:section];
    return section;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Add Service Delegate

- (void)SMAddServiceDelegate:(SMAddServiceViewController *)addServiceController didAddService:(SMOService *)service
{
    if (service) {
        // show the recipe in the RecipeDetailViewController
        NSDictionary *section = [self serviceSectionFor:service];
        if (section == nil) {
            section = [self newSectionFor:service];
        }
        NSMutableArray *sectionServices = section[@"services"];
        [sectionServices addObject:service];
        
        [self.tableView reloadData];
        [self performSegueWithIdentifier:@"editService" sender:service];
    }
    
    // dismiss the RecipeAddViewController
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.services.count;
//    NSInteger count = [self.fetchedResultsController sections].count;
//    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *sectionDictionary = self.services[section];
    NSMutableArray *sectionServices = sectionDictionary[@"services"];
    return sectionServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"Cell";
    
    SMServiceTableViewCell *serviceCell =
    (SMServiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:serviceCell atIndexPath:indexPath];
    
    return serviceCell;
}

- (void)configureCell:(SMServiceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    SMOService *service = [self serviceFor:indexPath];
    cell.service = service;
}

#pragma mark - Edit Service

- (void)addItemViewController:(SMEditServiceController *)controller servicio: (SMOService *)service
{
    [self.tableView reloadData];
    [controller.navigationController popViewControllerAnimated:YES];
    //Iniciar NSTimer
//    NSDate *d = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimer *t = [[NSTimer alloc] initWithFireDate: d
//                                          interval: [service.periodicity doubleValue]
//                                            target: self
//                                          selector:@selector(onTick:)
//                                          userInfo:service repeats:YES];
//    
//    NSRunLoop *runner = [NSRunLoop currentRunLoop];
//    [runner addTimer:t forMode: NSDefaultRunLoopMode];
}

#pragma mark - Do in Review

-(void)onTick:(NSTimer *)timer{
//    [reviewCenter reviewFtpService:timer.userInfo];
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        /* DELETE */
        [self deleteServiceAt:indexPath];
        
//		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//		
//		// Save the context.
//		NSError *error;
//		if (![context save:&error]) {
//			/*
//			 Replace this implementation with code to handle the error appropriately.
//			 
//			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//			 */
//			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//			abort();
//		}
	}
}

- (void) deleteServiceAt:(NSIndexPath *)indexPath {
    // Start web service
    NSMutableArray *services = [self serviceSectionForIndex:indexPath][@"services"];
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
    
    NSDictionary *sectionDictionary = self.services[section];
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

#pragma mark - Fetched results controller

//- (NSFetchedResultsController *)fetchedResultsController
//{
//    if(_fetchedResultsController == nil){
//        // 1 - Decide what Entity you want
//        NSString *entityName = @"SMOService";
//        NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
//        
//        // 2 - Request that Entity
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
//        
//        // 3 - Filter it if you want
//        //request.predicate = [NSPredicate predicateWithFormat:@"active = %@",[NSNumber numberWithBool:YES]];
//        
//        // 4 - Sort it if you want
//        NSSortDescriptor *sortDescriptor = nil;
//        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
//                                                     ascending:YES];
//        
//        
//        NSArray *sortDescriptors = [NSArray arrayWithObjects:
//                                    sortDescriptor,
//                                    nil];
//        
//        [request setSortDescriptors:sortDescriptors];
//        
//        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"type"
//                                                                                         ascending:YES
//                                                                                          selector:@selector(localizedCaseInsensitiveCompare:)]];
//        // 5 - Fetch it
//        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
//                                                                                                    managedObjectContext:self.managedObjectContext
//                                                                                                      sectionNameKeyPath:@"type"
//                                                                                                               cacheName:nil];
//        
//        aFetchedResultsController.delegate = self;
//        self.fetchedResultsController = aFetchedResultsController;
//    }
//    return _fetchedResultsController;
//}

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    
//	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
//	[self.tableView beginUpdates];
//}


//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//    
//	UITableView *tableView = self.tableView;
//	
//	switch(type) {
//		case NSFetchedResultsChangeInsert:
//			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeDelete:
//			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeUpdate:
//			[self configureCell:(SMServiceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//			break;
//			
//		case NSFetchedResultsChangeMove:
//			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//	}
//}

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    
//	switch(type) {
//		case NSFetchedResultsChangeInsert:
//			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeDelete:
//			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//	}
//}

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    
//	// The fetch controller has sent all current change notifications,
//    // so tell the table view to process all updates.
//	[self.tableView endUpdates];
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SMOService *service;
    if ([segue.identifier isEqualToString:@"editService"]) {
        
        SMEditServiceController *tsc = (SMEditServiceController *)segue.destinationViewController;
        tsc.managedObjectContext = self.managedObjectContext;
        if ([sender isKindOfClass:[SMOService class]]) {
            // the sender is the actual recipe send from "didAddRecipe" delegate (user created a new recipe)
            service = (SMOService *)sender;
        }
        else {
            // the sender is ourselves (user tapped an existing recipe)
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            service = [self serviceFor:indexPath];
        }
        tsc.service = service;
        tsc.delegate = self;
    }else if ([segue.identifier isEqualToString:@"addService"]){
        SMOService *newService = [NSEntityDescription insertNewObjectForEntityForName:@"SMOService"
                                                               inManagedObjectContext:self.managedObjectContext];
        UINavigationController *navController = segue.destinationViewController;
        SMAddServiceViewController *addController = (SMAddServiceViewController *)navController.topViewController;
        addController.delegate = self;  // do didAddRecipe delegate method is called when cancel or save are tapped
        addController.service = newService;
    }
    
}






@end

