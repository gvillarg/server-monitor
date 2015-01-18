//
//  SMOSound.m
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMOSound.h"


@implementation SMOSound
NSMutableArray *_sounds;

-(void)setAsUnavailableSound {
    [[NSUserDefaults standardUserDefaults] setObject:self.index forKey:@"unavailableSoundIndex"];
}
-(void)setAsChangedSound {
    [[NSUserDefaults standardUserDefaults] setObject:self.index forKey:@"changedSoundIndex"];
}

+(NSArray *)all {
    if (_sounds == nil) {
        _sounds = [[NSMutableArray alloc] init];
        
        SMOSound *sound;
        sound = [[SMOSound alloc] init];
        sound.name = @"Beep Beep 1";
        sound.sound = @"%@/bepbep1.mp3";
        sound.index = @0;
        [_sounds addObject:sound];
        
        sound = [[SMOSound alloc] init];
        sound.name = @"Beep Beep 2";
        sound.sound = @"%@/bepbep2.mp3";
        sound.index = @1;
        [_sounds addObject:sound];
        
        sound = [[SMOSound alloc] init];
        sound.name = @"Alert 1";
        sound.sound = @"%@/alert1.mp3";
        sound.index = @2;
        [_sounds addObject:sound];
        
        sound = [[SMOSound alloc] init];
        sound.name = @"Alert 2";
        sound.sound = @"%@/alert2.mp3";
        sound.index = @3;
        [_sounds addObject:sound];
        
        sound = [[SMOSound alloc] init];
        sound.name = @"Claxon";
        sound.sound = @"%@/claxon.mp3";
        sound.index = @4;
        [_sounds addObject:sound];
        
        sound = [[SMOSound alloc] init];
        sound.name = @"Error Code";
        sound.sound = @"%@/errorCode.mp3";
        sound.index = @5;
        [_sounds addObject:sound];
        
    }
    return _sounds;
}

+(SMOSound *)unavailableSound {
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:@"unavailableSoundIndex"];
    return [self all][[index integerValue]];
}

+(SMOSound *)changedSound {
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:@"changedSoundIndex"];
    return [self all][[index integerValue]];
}

+(void)setUnavailableSound:(SMOSound *)sound {
    [sound setAsUnavailableSound];
}
+(void)setChangedSound:(SMOSound *)sound {
    [sound setAsChangedSound];
}

@end
