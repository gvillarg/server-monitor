//
//  SMGeneralSettingTableViewController.m
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMGeneralSettingTableViewController.h"
#import "SMOSoundAlert.h"

@interface SMGeneralSettingTableViewController ()
    @property SMOSoundAlert *soundAlert;
@end

@implementation SMGeneralSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _soundAlert = [SMOSoundAlert create];
    _soundAlert.ipAlert = 0;
    [[IBCoreDataStore mainStore] save];
    NSArray *alerts = [SMOSoundAlert allOrderedBy:@"ipSound" ascending:YES];
    _soundAlert = alerts[0];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else{
        return 4;
    }
}

-(IBAction)stepperChangedValue:(UIStepper *)sender{
    
    //find row #
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //NSLog(@"value: %i",indexPath.row); //I have my row index here
    
    //my incremental number is here
    NSInteger i = [sender value];
    //NSLog(@"value: %i",i);
    cell.textLabel.text = [NSString stringWithFormat:@"%d Día(s)",i ]; // textField is an outlet for your textfield in your cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    if (indexPath.section == 0) {
        static NSString *identifier;
        identifier = @"CellCloud";
        UITableViewCell *serviceCell =
        (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        UIStepper* stepper = [[UIStepper alloc] init];
        stepper.minimumValue = 1;
        [stepper addTarget:self action:@selector(stepperChangedValue:) forControlEvents:UIControlEventValueChanged];
        stepper.frame = CGRectMake(220, 10, 100, 10);
        [serviceCell.contentView addSubview: stepper];
        serviceCell.textLabel.text = [NSString stringWithFormat:@"%d Día(s)", (int)[stepper value]];
        return serviceCell;
    }else if (indexPath.section == 1){
        static NSString *identifier;
        identifier = @"CellAlerta";
        if (indexPath.row == 0) {
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Sin Internet";
            return serviceCell;
        }else{
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Sin Conexión a iCloud";
            return serviceCell;
        }
    }else{
        static NSString *identifier;
        identifier = @"CellAlerta";
        if (indexPath.row == 0) {
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Menor a 10%";
            if (_soundAlert.unavailability) {
                serviceCell.detailTextLabel.text = ((SMOSound *)_soundAlert.unavailability).name;
            }
            return serviceCell;
        }else if(indexPath.row == 1){
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Entre 10% y 50%";
            if (_soundAlert.alert1050) {
                serviceCell.detailTextLabel.text = ((SMOSound *)_soundAlert.alert1050).name;
            }
            return serviceCell;
        }else if(indexPath.row == 2){
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Entre 50% y 70%";
            if (_soundAlert.alert5070) {
                serviceCell.detailTextLabel.text = ((SMOSound *)_soundAlert.alert5070).name;
            }
            return serviceCell;
        }else{
            UITableViewCell *serviceCell =
            (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            serviceCell.textLabel.text = @"Entre 70% y 99%";
            if (_soundAlert.alert7099) {
                serviceCell.detailTextLabel.text = ((SMOSound *)_soundAlert.alert7099).name;
            }
            return serviceCell;
        }//CellCrearAlerta
    }
    return NULL;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - SMSoundAlertsDelegate

- (void) SMSoundAlertsDelegate:(SMSoundAlertsTableViewController *)SMSoundAlertsTableViewController didAddService:(SMOSound *)sound selectedCell:(int)selectedCell{
    switch (selectedCell) {
        case 1:
            _soundAlert.unavailability = sound;
            break;
        case 2:
            _soundAlert.alert1050 = sound;
            break;
        case 3:
            _soundAlert.alert5070 = sound;
            break;
        default:
            _soundAlert.alert7099 = sound;
            break;
    }
    [[IBCoreDataStore mainStore] save];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Sincronización";
    }else if(section == 1){
        return @"Alertas Generales";
    }else{
        return @"Alertas por Rangos";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Frecuencia de sincronización con iCloud";
    }else if(section == 1){
        return @"Sonidos reproducidos al cumplirse situaciones anómalas en la red";
    }else{
        return @"Sonidos reproducidos al cumplirse situaciones anómalas con los servicios. Si el campo alerta del servicio está vacío, se reproduciran los sonidos configurados en esta sección. Si desea crear tipos de alertas, debe acceder a la última celda";
    }
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addSound"]) {
        SMSoundAlertsTableViewController *soundAlerts = segue.destinationViewController;
        soundAlerts.delegate = self;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        if (index.section == 2) {
            if (index.row == 0) {
                soundAlerts.selectedCell = 1;
            }else if (index.row == 1){
                soundAlerts.selectedCell = 2;
            }else if (index.row == 2){
                soundAlerts.selectedCell = 3;
            }else{
                soundAlerts.selectedCell = 4;
            }
        }
    }
}


@end
