//
//  SMSoundAlertsTableViewController.m
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMSoundAlertsTableViewController.h"
#import "SMOSound.h"
#import "SMContext.h"

@interface SMSoundAlertsTableViewController ()
    @property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation SMSoundAlertsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _managedObjectContext = [[SMContext sharedCenter] managedObjectContext];
    _selectedIndexPath = [[NSIndexPath alloc] init];
    /*
    NSError *error1 = nil;
    SMOSound *sound;
    sound = [NSEntityDescription insertNewObjectForEntityForName:@"SMOSound"
                                                    inManagedObjectContext:self.managedObjectContext];
    sound.name = @"Beep Beep 1";
    sound.sound = @"%@/bepbep1.mp3";
    [self.managedObjectContext save:&error1];
    sound = [NSEntityDescription insertNewObjectForEntityForName:@"SMOSound"
                                          inManagedObjectContext:self.managedObjectContext];
    sound.name = @"Beep Beep 2";
    sound.sound = @"%@/bepbep2.mp3";
    [self.managedObjectContext save:&error1];
    sound = [NSEntityDescription insertNewObjectForEntityForName:@"SMOSound"
                                          inManagedObjectContext:self.managedObjectContext];
    sound.name = @"Alert 1";
    sound.sound = @"%@/alert1.mp3";
    [self.managedObjectContext save:&error1];
    sound = [NSEntityDescription insertNewObjectForEntityForName:@"SMOSound"
                                          inManagedObjectContext:self.managedObjectContext];
    sound.name = @"Alert 2";
    sound.sound = @"%@/alert2.mp3";
    [self.managedObjectContext save:&error1];
    sound = [NSEntityDescription insertNewObjectForEntityForName:@"SMOSound"
                                          inManagedObjectContext:self.managedObjectContext];
    sound.name = @"Claxon";
    sound.sound = @"%@/claxon.mp3";
    [self.managedObjectContext save:&error1];
    sound = [NSEntityDescription insertNewObjectForEntityForName:@"SMOSound"
                                          inManagedObjectContext:self.managedObjectContext];
    sound.name = @"Error Code";
    sound.sound = @"%@/errorCode.mp3";
    [self.managedObjectContext save:&error1];
    */
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController == nil){
        // Initialize Fetch Request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SMOSound"];
        
        // Add Sort Descriptors
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        // Initialize Fetched Results Controller
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        // Configure Fetched Results Controller
        [self.fetchedResultsController setDelegate:self];
    }
    return _fetchedResultsController;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = [self.fetchedResultsController sections].count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    if ([self.fetchedResultsController sections].count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

-(IBAction)save:(id)sender{
    //[self.delegate didAddService]
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"Cell";
    
    UITableViewCell *soundCell =
    (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if([_selectedIndexPath isEqual:indexPath]){
        soundCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        soundCell.accessoryType = UITableViewCellAccessoryNone;
    }
    SMOSound *sound = (SMOSound *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    soundCell.textLabel.text = sound.name;
    return soundCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    [tableView reloadData];
    SMOSound *sound = (SMOSound *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:sound.sound, [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 1;
    if (audioPlayer == nil)
        NSLog([error description]);
    else
        [audioPlayer play];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [audioPlayer stop];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
