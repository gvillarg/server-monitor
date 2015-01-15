//
//  SMAddServiceViewController.h
//  Server Monitor
//
//  Created by Cesar on 10/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOService.h"
#import "SMPopUpUrlServices.h"

@protocol SMAddServiceDelegate;
@class Service;

@interface SMAddServiceViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, SMPopoUpUrlServicesDelegate>{
    NSMutableArray *selectedURL;
    NSMutableArray *type_array;
    UIPickerView *pickerTypeView;
}

@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (nonatomic, strong) SMOService *service;
@property (nonatomic, unsafe_unretained) id <SMAddServiceDelegate> delegate;
@property NSMutableArray *urlResult;

-(NSMutableArray *)lookupHostIPAddress:(NSString *)url;

@end



@protocol SMAddServiceDelegate <NSObject>

- (void)SMAddServiceDelegate:(SMAddServiceViewController *)SMAddServiceViewController didAddService:(SMOService *)service;

@end