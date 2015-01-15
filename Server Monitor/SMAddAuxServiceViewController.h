//
//  SMAddAuxServiceViewController.h
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOServicesAux.h"

@protocol SMAddAuxServiceViewControllerDelegate;

@interface SMAddAuxServiceViewController : UIViewController

@property (nonatomic, strong) SMOServicesAux* serviceAux;
@property (nonatomic) int type;
@property (nonatomic, unsafe_unretained) id <SMAddAuxServiceViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtURL;
@property (weak, nonatomic) IBOutlet UITextField *txtPort;

@end

@protocol SMAddAuxServiceViewControllerDelegate <NSObject>

- (void)SMAddServiceDelegate:(SMAddAuxServiceViewController *)SMAddAuxServiceViewController didAddService:(SMOServicesAux *)service;
- (void)SMAddServiceDelegate:(SMAddAuxServiceViewController *)SMAddAuxServiceViewController didDeleteService:(SMOServicesAux *)service arg2:(int)type;

@end