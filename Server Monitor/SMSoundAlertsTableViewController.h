//
//  SMSoundAlertsTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SMOSound.h"

@protocol SMSoundAlertsDelegate;

@interface SMSoundAlertsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    AVAudioPlayer *audioPlayer;
}
    @property (nonatomic, unsafe_unretained) id <SMSoundAlertsDelegate> delegate;
    @property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
    @property NSInteger selectedCell;
@end

@protocol SMSoundAlertsDelegate <NSObject>

- (void)SMSoundAlertsDelegate:(SMSoundAlertsTableViewController *)SMSoundAlertsTableViewController didAddService:(SMOSound *)sound selectedCell: (NSInteger) selectedCell;

@end
