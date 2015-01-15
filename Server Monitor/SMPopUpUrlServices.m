//
//  SMPopUpUrlServices.m
//  Server Monitor
//
//  Created by Cesar on 16/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMPopUpUrlServices.h"

@implementation SMPopUpUrlServices

@synthesize isShown;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originalFrame = frame;
        
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake(0, 5, frame.size.width, 15);
        [closeButton setTitle:@"Cerrar" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    ipTable = [self makeTableView];
    [ipTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self addSubview:ipTable];
    ipSelected = [[NSMutableArray alloc] init];
    return self;
}


#pragma mark Custom alert methods

- (void)show
{
    NSLog(@"show");
    isShown = YES;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = 1;
    [UIView commitAnimations];
}

- (void)show:(NSMutableArray *)ips
{
    NSLog(@"show");
    isShown = YES;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = 1;
    _ipList = ips;
    [UIView commitAnimations];
}

- (void)hide
{
    NSLog(@"hide");
    isShown = NO;
    [UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [self.delegate setUrlList:ipSelected];
    [UIView commitAnimations];
}

- (void)toggle
{
    if (isShown) {
        [self hide];
    } else {
        [self show];
    }
}

#pragma mark Animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showAlert"]) {
        if (finished) {
            [UIView beginAnimations:nil context:nil];
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView commitAnimations];
        }
    } else if ([animationID isEqualToString:@"hideAlert"]) {
        if (finished) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.frame = originalFrame;
        }
    }
}

#pragma mark Touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    lastTouchLocation = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint newTouchLocation = [touch locationInView:self];
    CGRect currentFrame = self.frame;
    
    CGFloat deltaX = lastTouchLocation.x - newTouchLocation.x;
    CGFloat deltaY = lastTouchLocation.y - newTouchLocation.y;
    
    self.frame = CGRectMake(currentFrame.origin.x - deltaX, currentFrame.origin.y - deltaY, currentFrame.size.width, currentFrame.size.height);
    lastTouchLocation = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Table View

-(UITableView *)makeTableView
{
    CGFloat x = 0;
    CGFloat y = 30;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height - 5;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.allowsMultipleSelection =YES;
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = 0;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ipList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
    cell.textLabel.text = [_ipList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [ipSelected addObject:_ipList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    [ipSelected removeObject:_ipList[indexPath.row]];
}


@end
