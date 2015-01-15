//
//  SMViewServiceTableViewController.m
//  Server Monitor
//
//  Created by Cesar on 13/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMViewServiceTableViewController.h"
#import "AFNetworking.h"
#import "SMOServiceAccess.h"
#import "SMWebService.h"



@interface SMViewServiceTableViewController (){
    UIWebView *webView;
    BOOL respuesta;
    NSString *texto;
    
}

@end

@implementation SMViewServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    respuesta = false;
    _serviceDecode = [[NSMutableDictionary alloc] init];
    if ([_service.type isEqualToString: [SMOService webService]]) {

    }else if ([_service.type isEqualToString: [SMOService webPage]]){
        [self initWebPage];
    }else{
        [self initFtp:@"/"];
    }

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - WebPage

- (void) initWebPage{
    // 1
    NSURL *targetURL = [NSURL URLWithString:self.service.serviceAccess.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSArray *components = [dataString componentsSeparatedByString:@"<"];
    for (int i=0; i<components.count; i++) {
        NSArray *data = [components[i] componentsSeparatedByString:@">"];
        [_serviceDecode setValue:data.count>1?data[1]:@"" forKey:data[0]];
    }
    //NSLog(@"%@", dataString);
    // 8
    //[self.tableView reloadData];
}

#pragma mark - FTP


-(void)initFtp: (NSString *) destination{
    //we don't autorelease the object so that it will be around when the callback gets called
    //this is not a good practice, in real life development you should use a retain property to store a reference to the request
    WRRequestListDirectory * listDir = [[WRRequestListDirectory alloc] init];
    listDir.delegate = self;
    
    
    //the path needs to be absolute to the FTP root folder.
    //if we want to list the root folder we let the path nil or /
    //full URL would be ftp://xxx.xxx.xxx.xxx/
    listDir.path = destination;
    
    listDir.hostname = _service.serviceAccess.url;
    listDir.username = _service.serviceAccess.user;
    listDir.password = _service.serviceAccess.password;
    
    listDir.service = _service;
    
    [listDir start];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void) requestCompleted:(WRRequest *) request service:(SMOService *)service{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //called after 'request' is completed successfully
    NSLog(@"%@ completed!", request);
    
    //we cast the request to list request
    WRRequestListDirectory * listDir = (WRRequestListDirectory *)request;
    
    //we print each of the files name
    for (NSDictionary * file in listDir.filesInfo) {
        if (![[file objectForKey:(id)kCFFTPResourceName] isEqualToString: @"."] && ![[file objectForKey:(id)kCFFTPResourceName] isEqualToString: @".."]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSString *fecha = [formatter stringFromDate:[file objectForKey:(id)kCFFTPResourceModDate]];
            NSString *tam = [[file objectForKey:(id)kCFFTPResourceSize] stringValue];
            [_serviceDecode setValue:[[[fecha stringByAppendingString:@" - "] stringByAppendingString:tam] stringByAppendingString:@" kb"]forKey:[file objectForKey:(id)kCFFTPResourceName]];
        }
    }
    [self.tableView reloadData];
    //"kCFFTPResourceModDate"
    //	@"kCFFTPResourceSize"
}

-(void) requestFailed:(WRRequest *) request{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //called if 'request' ends in error
    //we can print the error message
    NSLog(@"%@", request.error.message);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  [self.serviceDecode count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id key = [self.serviceDecode allKeys][indexPath.row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [self.serviceDecode objectForKey:key];
    // Configure the cell...
    
    return cell;
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

- (IBAction)tabClose:(id)sender{
    [self.delegate closeView];
}

- (IBAction)tabSave:(id)sender{
    [self.delegate saveDictionary:_serviceDecode];
}

@end
