//
//  SMServiceSettingTableViewController.m
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMServiceSettingTableViewController.h"
#import "SMContext.h"


@interface SMServiceSettingTableViewController ()

@end

@implementation SMServiceSettingTableViewController

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
    _managedObjectContext = [[SMContext sharedCenter] managedObjectContext];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *identifier;
            identifier = @"GeneralCell";
            
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Generales";
            return serviceCell;
        }else{
            static NSString *identifier;
            identifier = @"ServicesCell";
            
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Servicios de Referencia";
            return serviceCell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString *identifier;
            identifier = @"AboutCell";
            
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Acerca de";
            return serviceCell;
        }
    }
    return NULL;
}

#pragma mark - UITableViewDelegate


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Configuraciones Generales";
    }else{
        return @"Otros";
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GeneralSettings"]) {
        UINavigationController *navController = segue.destinationViewController;
        SMGeneralSettingTableViewController *gs = (SMGeneralSettingTableViewController *)navController;
        gs.managedObjectContext = self.managedObjectContext;
    }else if ([segue.identifier isEqualToString:@"AuxServices"]){
        UINavigationController *navController = segue.destinationViewController;
        SMAuxServicesTableViewController *auxServices = (SMAuxServicesTableViewController *)navController;
        auxServices.managedObjectContext = self.managedObjectContext;
    }

    
}


@end
