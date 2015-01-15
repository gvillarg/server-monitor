//
//  SMAddAuxServiceViewController.m
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMAddAuxServiceViewController.h"

@interface SMAddAuxServiceViewController ()

@end

@implementation SMAddAuxServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txtName.text = _serviceAux.name;
    _txtURL.text = _serviceAux.url;
    _txtPort.text = [_serviceAux.port stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveAuxService:(id)sender{
    _serviceAux.name = _txtName.text;
    _serviceAux.url = _txtURL.text;
    _serviceAux.port = [NSNumber numberWithUnsignedInteger: [_txtPort.text integerValue]];
    [self.delegate SMAddServiceDelegate:self didAddService:self.serviceAux];
}

-(IBAction)cancelAuxService:(id)sender{
    [self.delegate SMAddServiceDelegate:self didDeleteService:self.serviceAux arg2:self.type];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
