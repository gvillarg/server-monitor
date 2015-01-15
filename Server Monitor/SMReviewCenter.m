//
//  SMReviewCenter.m
//  Server Monitor
//
//  Created by Cesar on 20/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMReviewCenter.h"
#import "SMOServiceAccess.h"
#import "SMOServiceIP.h"
#import "SMOServiceAvailabilityDetail.h"
#import "SMOSoundAlert.h"

@implementation SMReviewCenter



#pragma mark - Do in Review Web Service

-(void)createRevision:(SMOService *)service{
    if ([service.type isEqualToString:[SMOService webService]]) {
        [self reviewWebService:service];
    }else if([service.type isEqualToString:[SMOService webPage]]){
        [self reviewWebPage:service];
    }else{
        //[self];
    }
}

#pragma mark - Do in Review Web Service

-(void)reviewWebService: (SMOService *)service{
    
}

#pragma mark - Do in Review FTP Service

-(void)reviewFtpService: (SMOService *)service{
    for (int i=0; i<service.serviceIP.count; i++) {
        WRRequestListDirectory * listDir = [[WRRequestListDirectory alloc] init];
        listDir.delegate = self;
        
        
        //the path needs to be absolute to the FTP root folder.
        //if we want to list the root folder we let the path nil or /
        //full URL would be
        listDir.path = @"/";
        
        listDir.hostname = service.serviceAccess.url;
        listDir.username = service.serviceAccess.user;
        listDir.password = service.serviceAccess.password;
        
        listDir.service = service;
        
        [listDir start];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

-(void) requestCompleted:(WRRequest *) request service:(SMOService *)service{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //called after 'request' is completed successfully
    NSLog(@"%@ completed!", request);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    //we cast the request to list request
    WRRequestListDirectory * listDir = (WRRequestListDirectory *)request;
    
    //we print each of the files name
    for (NSDictionary * file in listDir.filesInfo) {
        if (![[file objectForKey:(id)kCFFTPResourceName] isEqualToString: @"."] && ![[file objectForKey:(id)kCFFTPResourceName] isEqualToString: @".."]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSString *fecha = [formatter stringFromDate:[file objectForKey:(id)kCFFTPResourceModDate]];
            NSString *tam = [[file objectForKey:(id)kCFFTPResourceSize] stringValue];
            NSString *nombre = [file objectForKey:(id)kCFFTPResourceName];
            NSString *value = [[[fecha stringByAppendingString:@" - "] stringByAppendingString:tam] stringByAppendingString:@" kb"];
            [dictionary setObject:value forKey:nombre];
        }
    }
    NSArray *array = [service.baseService allObjects];
    SMOBaseService *base = array[service.baseService.count-1];
    NSDictionary *baseD = (NSDictionary *)base.baseService;
    [self analizeFTP:dictionary base:baseD service: service];
    //"kCFFTPResourceModDate"
    //	@"kCFFTPResourceSize"
}

- (void) analizeFTP: (NSDictionary *) download base: (NSDictionary *)base service: (SMOService *)service{
    float value = [SMCompareServices compareStructureFTP:base downloaded: download];
    NSLog(@"%f",value);
    
    SMOServiceContent *contentService = [NSEntityDescription insertNewObjectForEntityForName:@"SMOServiceContent" inManagedObjectContext:service.managedObjectContext];
    contentService.similarityRate = [NSNumber numberWithFloat:value];
    contentService.serviceDownloaded = download;
    contentService.monitorDate = [NSDate date];
    
    SMOServiceIP *serviceIP = service.serviceIP[0];
    [serviceIP addServiceContentObject:contentService];
    NSError *error = nil;
    if (![service.managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void) requestFailed:(WRRequest *) request{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //called if 'request' ends in error
    //we can print the error message
    NSLog(@"%@", request.error.message);
    
}

#pragma mark - Do in Review Web Service

-(void)reviewWebPage: (SMOService *)service{
    
}


-(void)AlertrCenter: (SMOService *)service{
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    
    // Set the notification time.
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    // You can specify the alarm sound here.
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //OR
    //localNotification.soundName = service.alert.alert1050;
    
    // Set the alertbody of the notification here.
    localNotification.alertBody = @"Test Alert";
    
    // Create the buttons on the notification alertview.
    localNotification.alertAction = [@"Problemas con el servicio " stringByAppendingString: service.name];
    
    // You can also specify custom dictionary to store informations
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"alarm#2" forKey:@"notifiKey"];
    localNotification.userInfo = infoDict;
    
    //Repeat the notification.
    localNotification.repeatInterval = NSDayCalendarUnit;
    
    // Schedule the notification
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
}

@end
