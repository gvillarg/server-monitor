//
//  SMContentTableViewController.m
//  Server Monitor
//
//  Created by Gustavo Villar on 1/17/15.
//  Copyright (c) 2015 PUCP. All rights reserved.
//

#import "AFNetworking.h"
#import "SMContentTableViewController.h"
#import "SMContentTableViewCell.h"
#import "SMOServiceAvailability.h"

@implementation SMContentTableViewController {
    NSArray *contents;
}

-(void)viewDidLoad {
    [self loadServiceDownload];
}

-(void) loadServiceDownload {
    
    NSString *string = [NSString stringWithFormat:@"%@/ServiceDownload/%@", URL_STRING, self.availability.idServiceTest];
    NSLog(@"%@", string);
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        NSLog(@"%@", responseObject);
        contents = responseObject;
        [self.tableView reloadData];
//        [self initFakeData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contents.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *content = contents[indexPath.row];
    
    SMContentTableViewCell *cell =
    (SMContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = content[@"keyobject"];
    cell.valueLabel.text = content[@"valueobject"];
    NSString *imageName;
    NSNumber *status = content[@"different"];
    switch ([status integerValue]) {
        case 1:
            imageName = @"plus";
            break;
        case 2:
            imageName = @"minus";
            break;
        case 3:
            imageName = @"warning";
            break;
        default:
            break;
    }
//    NSLog(@"%@", imageName);
    cell.image.image = [UIImage imageNamed:imageName];
    return cell;
}

@end
