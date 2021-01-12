//
//  NSDate+TMExtension.m
//  SmeUsa
//
//  Created by Abel Sánchez Custodio on 9/8/15.
//  Copyright (c) 2015 talentoMobile. All rights reserved.
//

#import "NSDate+TMExtension.h"

@implementation NSDate (TMExtension)

+ (NSString *)dateFromFormat:(NSDate *)date dateFormatString:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es_MEX"];
    
    NSString *sDate = [[dateFormatter stringFromDate:date] capitalizedString];
    
    sDate = ([sDate containsString:@" De "]) ? [sDate stringByReplacingOccurrencesOfString:@" De " withString:@" de "] : sDate;
    
    return sDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format
{    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"es_MEX"];
    
    return [self dateFromString:dateString format:format locale:locale];
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format locale:(NSLocale *)locale
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    dateFormatter.dateFormat = format;
    
    if (locale)
    {
        dateFormatter.locale = locale;
    }
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)defaultTimestampForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es_MEX"];

    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)defaultTimestampForDateIn24HourFormat:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es_MEX"];

    return [dateFormatter stringFromDate:date];
}

- (NSComparisonResult)compareWithoutTime:(NSDate *)other
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate:self];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate:other];
    
    NSDate *selfDate = [calendar dateFromComponents:date1Components];
    NSDate *otherDate = [calendar dateFromComponents:date2Components];
    
    return [selfDate compare:otherDate];
}

- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays
{
    return [self dateByAddingTimeInterval:60*60*24*numberOfDays];
}

- (NSDate *)dateByRestingMonth:(NSInteger)numberOfMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setMonth:-numberOfMonths];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateByRestingDays:(NSInteger)numberOfDays
{
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    
//    [dateComponents setDay:-numberOfDays];
//    
//    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return [self dateByAddingTimeInterval:-60*60*24*numberOfDays];
}

+ (NSDate *)getDateMX
{
    NSDate* sourceDate = [NSDate date];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    return destinationDate;
}

@end
