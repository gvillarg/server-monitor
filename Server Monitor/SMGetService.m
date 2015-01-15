//
//  SMGetService.m
//  Server Monitor
//
//  Created by Cesar on 6/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMGetService.h"
#import "SMOServiceAccess.h"
#import "AFNetworking.h"


@implementation SMGetService

@synthesize jsonParsed = _jsonParsed;
-(NSDictionary *)getJson:(SMOService *)service{
    NSString *string = service.serviceAccess.url;
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        _jsonParsed = (NSDictionary *)responseObject;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    NSL
    return _jsonParsed;
}

@end
