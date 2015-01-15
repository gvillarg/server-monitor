//
//  SMEditServiceController.h
//  Server Monitor
//
//  Created by Cesar Otoya on 7/22/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOService.h"
#import "SMOServiceAccess.h"
#import "SMOBaseService.h"
#import "SMViewServiceTableViewController.h"

@class SMEditServiceController;
@protocol SMEditServiceControllerDelegate

- (void)addItemViewController:(SMEditServiceController *)controller servicio: (SMOService *)servicio
;
    
@end

@interface SMEditServiceController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, SMViewServiceDelegate>{
    NSMutableArray *period_array;
    UIPickerView *pickerPeriod;
    
}

@property (nonatomic, weak) id <SMEditServiceControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *type_text;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UISwitch *security;
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *similarity;
@property (weak, nonatomic) IBOutlet UIStepper *changeSimilarity;
@property (weak, nonatomic) IBOutlet UISwitch *recusive;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UIImageView *separatorLine;
@property (weak, nonatomic) IBOutlet UIButton *ping;
@property (weak, nonatomic) IBOutlet UITextField *periodicityNumber;
@property (weak, nonatomic) IBOutlet UITextField *periodicityUnit;
@property (weak, nonatomic) IBOutlet UITextField *swMode;
@property (weak, nonatomic) IBOutlet UISwitch *pwLibrary;
@property (weak, nonatomic) IBOutlet UISwitch *pwParse;

@property (strong) SMOService *service;
@property (strong) SMOServiceAccess *serviceAccess;
@property (strong,nonatomic) NSDate *start;

-(NSInteger)convertPeriod;
-(void)convertPeriod:(NSInteger)quantity;

@end
