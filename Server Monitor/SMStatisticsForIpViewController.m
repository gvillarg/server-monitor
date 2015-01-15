//
//  SMStatisticsForIpViewController.m
//  Server Monitor
//
//  Created by Cesar on 23/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMStatisticsForIpViewController.h"

#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "SMWebService.h"
#import "AFNetworking.h"

#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, JBLineChartLine){
	JBLineChartLineSolid,
    JBLineChartLineDashed,
    JBLineChartLineCount
};
/*CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeight)*/
// Numerics

CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 100.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 50.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 2.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;

@interface SMStatisticsForIpViewController() <JBLineChartViewDelegate, JBLineChartViewDataSource>{
    NSMutableDictionary *datos;
}

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *daysOfWeek;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data

@end

@implementation SMStatisticsForIpViewController

#pragma mark - Alloc/Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Disponibilidad", @"Contenido"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentedControl;
    self.navigationController.navigationBar.topItem.title = @" ";
    self.navigationItem.prompt = self.serviceIP.addressIp;
    NSArray *monitoreo = [self.serviceIP.serviceContent allObjects];
    datos = [[NSMutableDictionary alloc] init];
    for (int i=0; i<monitoreo.count; i++) {
        SMOServiceContent *content = monitoreo[i];
        [datos setObject:content.similarityRate forKey:content.monitorDate];
    }
    [self initFakeData];
    [self loadServiceVerify];
}

// Services
-(void) loadServiceVerify {
    
    NSString *string = [NSString stringWithFormat:@"%@/ServiceVerify/%@", URL_STRING, self.serviceIP.idserviceIP];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *responseObject) {
        
        NSLog(@"%@", responseObject);        
        [self.tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"¡Ups! Ha ocurrido un error."
                                  message: @"La dirección no se encuentra disponible"
                                  delegate: nil
                                  cancelButtonTitle: @"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
    }];
    
    [operation start];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //[self initFakeData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //[self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Data

- (void)initFakeData
{
    NSArray *llaves;
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
    for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
    {
        NSMutableArray *mutableChartData = [NSMutableArray array];
        
        llaves = [datos allKeys];
        llaves = [llaves sortedArrayUsingComparator:
                                ^(id obj1, id obj2)
                                {
                                    return [(NSDate*) obj2 compare: (NSDate*)obj1];
                                }
                                ];
        for (int i=0; i<kJBLineChartViewControllerMaxNumChartPoints; i++)
        {
            if (i<datos.count){
                [mutableChartData addObject:[datos objectForKey:llaves[i]]]; // random number between 0 and 1
            }else{
                [mutableChartData addObject:[NSNumber numberWithInt:0]];
            }
        }
        [mutableLineCharts addObject:mutableChartData];
    }
    
    _chartData = [NSArray arrayWithArray:mutableLineCharts];
    _daysOfWeek = llaves;
    [self.lineChartView reloadData];
}

- (NSArray *)largestLineData
{
    NSArray *largestLineData = nil;
    for (NSArray *lineData in self.chartData)
    {
        if ([lineData count] > [largestLineData count])
        {
            largestLineData = lineData;
        }
    }
    return largestLineData;
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding*3, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = @"Antes";
    footerView.leftLabel.textColor = [UIColor blackColor];
    footerView.rightLabel.text = @"Ahora";
    footerView.rightLabel.textColor = [UIColor blackColor];
    footerView.sectionCount = [[self largestLineData] count];
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview:self.lineChartView];
    

    
    [self.lineChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChartView setState:JBChartViewStateExpanded];
}

#pragma mark - JBChartViewDataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return [self.chartData count];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [[self.chartData objectAtIndex:lineIndex] count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == JBLineChartViewLineStyleSolid;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    //NSNumber *valueNumber = [[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *fecha;
    if (horizontalIndex < datos.count) {
        fecha = [formatter stringFromDate:[self.daysOfWeek objectAtIndex:horizontalIndex]];
    }else fecha = @"-";
    [self.tooltipView setText:fecha];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self setTooltipVisible:NO animated:YES];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBLineChartViewControllerChartSolidLineWidth: kJBLineChartViewControllerChartDashedLineWidth;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? 0.0: (kJBLineChartViewControllerChartDashedLineWidth * 4);
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor lightGrayColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? JBLineChartViewLineStyleSolid : JBLineChartViewLineStyleDashed;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return datos.count;
    }else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"CellPW";
    
    UITableViewCell *serviceCell =
    (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSArray *llaves = [datos allKeys];
    llaves = [llaves sortedArrayUsingComparator:
              ^(id obj1, id obj2)
              {
                  return [(NSDate*) obj2 compare: (NSDate*)obj1];
              }
              ];

    NSDate *key = llaves[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *fecha = [formatter stringFromDate:key];
    float rate = [[datos objectForKey:key] floatValue];
    rate*=100;
    serviceCell.textLabel.text = fecha;
    serviceCell.detailTextLabel.text = [NSString stringWithFormat:@"%f%%",rate];
    return serviceCell;
}



#pragma mark - UITableViewDelegate






#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.lineChartView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
