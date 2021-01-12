//
//  NSDate+TMExtension.h
//  SmeUsa
//
//  Created by Abel Sánchez Custodio on 9/8/15.
//  Copyright (c) 2015 talentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TMExtension)

+ (NSString *)dateFromFormat:(NSDate *)date dateFormatString:(NSString *)dateFormat;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format locale:(NSLocale *)locale;

+ (NSString *)defaultTimestampForDate:(NSDate *)date;
+ (NSString *)defaultTimestampForDateIn24HourFormat:(NSDate *)date;
+ (NSDate *)getDateMX;

- (NSComparisonResult)compareWithoutTime:(NSDate *)other;

- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays;
- (NSDate *)dateByRestingDays:(NSInteger)numberOfDays;
- (NSDate *)dateByRestingMonth:(NSInteger)numberOfMonths;

@end
