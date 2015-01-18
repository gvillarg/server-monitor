//
//  SMAvailabilityViewController.m
//  Server Monitor
//
//  Created by Gustavo Villar on 1/17/15.
//  Copyright (c) 2015 PUCP. All rights reserved.
//

#import "SMAvailabilityViewController.h"

@implementation SMAvailabilityViewController

-(void)viewDidLoad {
    self.ping1Label.text = [NSString stringWithFormat:@"Ping 1: %@", self.availability.avgPingService1];
    self.ping2Label.text = [NSString stringWithFormat:@"Ping 2: %@", self.availability.avgPingService2];
    self.ping3Label.text = [NSString stringWithFormat:@"Ping 3: %@", self.availability.avgPingService3];
}

@end
