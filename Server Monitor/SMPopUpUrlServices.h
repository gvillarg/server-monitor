//
//  SMPopUpUrlServices.h
//  Server Monitor
//
//  Created by Cesar on 16/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPopoUpUrlServicesDelegate

-(void) setUrlList:(NSMutableArray *)url;

@end

@interface SMPopUpUrlServices : UIView<UITableViewDataSource, UITableViewDelegate>{
    UITableView *ipTable;
    CGPoint lastTouchLocation;
    CGRect originalFrame;
    BOOL isShown;
    NSMutableArray *ipSelected;
}
@property (nonatomic,weak) id <SMPopoUpUrlServicesDelegate> delegate;
@property (nonatomic) BOOL isShown;
@property (nonatomic)





































































































NSMutableArray *ipList;

- (void)show:(NSMutableArray *) ips;
- (void)hide;

@end
