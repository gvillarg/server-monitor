//
//  SMViewServiceTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 13/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOService.h"
#import "WhiteRaccoon.h"


@protocol SMViewServiceDelegate;

@interface SMViewServiceTableViewController : UITableViewController<WRRequestDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savebutton;

@property (nonatomic, strong) SMOService *service;
@property (nonatomic, unsafe_unretained) id <SMViewServiceDelegate> delegate;

@property NSDictionary *serviceDecode;

@end

@protocol SMViewServiceDelegate <NSObject>

- (void) closeView;
- (void) saveDictionary: (NSDictionary *)data;

@end