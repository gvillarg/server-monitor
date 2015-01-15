//
//  JBColorConstants.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/7/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#pragma mark - Line Chart

#define kJBColorLineChartControllerBackground [UIColor colorWithWhite:1 alpha:1.0]
#define kJBColorLineChartBackground [UIColor colorWithWhite:1 alpha:1.0]
#define kJBColorLineChartHeader [UIColor colorWithWhite:0 alpha:1.0]
#define kJBColorLineChartHeaderSeparatorColor [UIColor colorWithWhite:0 alpha:1.0]
#define kJBColorLineChartDefaultSolidLineColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]
#define kJBColorLineChartDefaultSolidSelectedLineColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define kJBColorLineChartDefaultDashedLineColor [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
#define kJBColorLineChartDefaultDashedSelectedLineColor [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:5.0]



#pragma mark - Tooltips

#define kJBColorTooltipColor [UIColor colorWithRed:0.2 green:0.7 blue:0.7 alpha:0.9]
#define kJBColorTooltipTextColor UIColorFromHex(0x313131)
