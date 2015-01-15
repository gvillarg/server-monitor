//
//  SMReviewCenter.h
//  Server Monitor
//
//  Created by Cesar on 20/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SMOService.h"
#include "WhiteRaccoon.h"
#import "SMOBaseService.h"
#import "SMCompareServices.h"
#import "SMOServiceContent.h"

@interface SMReviewCenter : NSObject <WRRequestDelegate>

@property (nonatomic, strong) NSMutableArray *servicios;

-(void)reviewFtpService: (SMOService *)service;

@end
