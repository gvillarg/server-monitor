//
//  SMStatisticsForIpViewController.h
//  Server Monitor
//
//  Created by Cesar on 23/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOServiceContent.h"   
#import "SMOServiceIP.h"
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBConstants.h"
#import "JBLineChartFooterView.h"
#import "JBBaseChartViewController.h"


@interface SMStatisticsForIpViewController : JBBaseChartViewController<JBLineChartViewDelegate, JBLineChartViewDataSource, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UISegmentedControl *segmentedControl;
@property (nonatomic, strong) SMOServiceIP *serviceIP;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data

@end

