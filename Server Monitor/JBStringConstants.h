//
//  JBStringConstants.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#define localize(key, default) NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], default, nil)

#pragma mark - Labels

#pragma mark - Labels (Line Chart)

#define kJBStringLabel2013 localize(@"label.2013", @"2013")
#define kJBStringLabelSanFrancisco2013 localize(@"label.san.francisco.2013", @"San Francisco - 2013")
#define kJBStringLabelAverageDailyRainfall localize(@"label.average.daily.rainfall", @"Tiempo de respuesta promedio")
#define kJBStringLabelMm localize(@"label.mm", @"mm")
#define kJBStringLabelMetropolitanAverage localize(@"label.metropolitan.average", @"Metropolitan Average")
#define kJBStringLabelNationalAverage localize(@"label.national.average", @"National Average")
