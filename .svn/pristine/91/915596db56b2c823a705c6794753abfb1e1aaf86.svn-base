//
//  RSAMobileSDK.m
//  SmeUsa
//
//  Created by Rafael Maiquez on 20/8/15.
//  Copyright (c) 2015 talentoMobile. All rights reserved.
//

#import "RSAMobileSDK.h"
#import "KMobileAPI.h"
#import <Foundation/NSJSONSerialization.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation RSAMobileSDK

static RSAMobileSDK *sharedInstance = nil;

+ (RSAMobileSDK *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
        [sharedInstance initComponents];
    }
    return sharedInstance;
}

- (void) initComponents
{
#if TARGET_IPHONE_SIMULATOR
    
#else
    mConfiguration = COLLECT_ALL_DEVICE_DATA_AND_LOCATION;
    [self initArrays];

    mMobileAPI = [[MobileAPI alloc]init];
    NSNumber *configuration = [[NSNumber alloc]initWithInt: mConfiguration];
    NSNumber *timeout = [[NSNumber alloc]initWithInt:TIMEOUT_DEFAULT_VALUE];
    NSNumber *silencePeriod = [[NSNumber alloc]initWithInt:SILENT_PERIOD_DEFAULT_VALUE];
    NSNumber *bestAge = [[NSNumber alloc]initWithInt:BEST_LOCATION_AGE_MINUTES_DEFAULT_VALUE];
    NSNumber *maxAge = [[NSNumber alloc]initWithInt:MAX_LOCATION_AGE_DAYS_DEFAULT_VALUE];
    
    ///NSNumber *maxAccuracy = [[NSNumber alloc]initWithInt:MAX_ACCURACY_DEFAULT_VALUE];
    // override default accuracy in order to force GPS collection
    NSNumber *maxAccuracy = [[NSNumber alloc]initWithInt: 50];
    
    NSDictionary *properties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                configuration, CONFIGURATION_KEY,
                                timeout, TIMEOUT_MINUTES_KEY,
                                silencePeriod, SILENT_PERIOD_MINUTES_KEY,
                                bestAge, BEST_LOCATION_AGE_MINUTES_KEY,
                                maxAge, MAX_LOCATION_AGE_DAYS_KEY,
                                maxAccuracy, MAX_ACCURACY_KEY,
                                @"1", ADD_TIMESTAMP_KEY,
                                nil];
    
    mMobileAPIInitialized = [mMobileAPI initSDK: properties];
    
    // The following code demonstrates how to add custom elements of each type to the JSON string
    
    [mMobileAPI addCustomElement:CUSTOM_ELEMENT_TYPE_STRING elementName:@"CustomString" elementValue:@"StringValue"];
    
    NSNumber* customBool = [[NSNumber alloc]initWithBool:TRUE];
    [mMobileAPI addCustomElement:CUSTOM_ELEMENT_TYPE_BOOL elementName:@"CustomBool" elementValue:customBool];
    
    NSNumber* customInteger = [[NSNumber alloc]initWithLongLong:123456789];
    [mMobileAPI addCustomElement:CUSTOM_ELEMENT_TYPE_INTEGER elementName:@"CustomInteger" elementValue:customInteger];
    
    NSDecimalNumber* customDecimal = [[NSDecimalNumber alloc]initWithDouble:3.14159];
    [mMobileAPI addCustomElement:CUSTOM_ELEMENT_TYPE_DECIMAL elementName:@"CustomDecimal" elementValue:customDecimal];
    
    // Get the JSON string
    mJSONInfoString = [mMobileAPI collectInfo];
#endif
}

-(void)initArrays
{
    mInfoItems = [[NSArray alloc] initWithObjects:
                  @"Mobile SDK Version",
                  @"Hardware ID",
                  @"SIM ID",
                  @"Phone Number",
                  @"Geo-location Data",
                  @"Device model",
                  @"Device multitasking supported",
                  @"Device Name",
                  @"Device System Name",
                  @"Device System Version",
                  @"Languages",
                  @"Wi-Fi MAC Address",
                  @"Wi-Fi Networks data",
                  @"Cell Tower ID",
                  @"Location area code",
                  @"Screen size",
                  @"RSA Application key",
                  @"MCC",
                  @"MNC",
                  @"OS ID",
                  @"Compromised",
                  @"Emulator",
                  @"TimeStamp",
                  
                  @"CustomDecimal",
                  @"CustomInteger",
                  @"CustomString",
                  @"CustomBool",
                  @"AdvertiserId",
                
                  
                  nil];
    mJsonKeys = [[NSArray alloc] initWithObjects:
                 @"SDK_VERSION",
                 @"HardwareID",
                 @"SIM_ID",
                 @"PhoneNumber",
                 @"GeoLocationInfo",
                 @"DeviceModel",
                 @"MultitaskingSupported",
                 @"DeviceName",
                 @"DeviceSystemName",
                 @"DeviceSystemVersion",
                 @"Languages",
                 @"WiFiMacAddress",
                 @"WiFiNetworksData",
                 @"CellTowerId",
                 @"LocationAreaCode",
                 @"ScreenSize",
                 @"RSA_ApplicationKey",
                 @"MCC",
                 @"MNC",
                 @"OS_ID",
                 @"Compromised",
                 @"Emulator",
                 @"TIMESTAMP",
                 @"CustomDecimal",
                 @"CustomInteger",
                 @"CustomString",
                 @"CustomBool",
                 @"AdvertiserId",
                 
                 nil];
    
    mJsonLocationKeys = [[NSArray alloc] initWithObjects:
                         @"Latitude",
                         @"Longitude",
                         @"HorizontalAccuracy",
                         @"Altitude",
                         @"AltitudeAccuracy",
                         @"Heading",
                         @"Speed",
                         @"TimeStamp",
                         @"Status",
                         nil];
}

- (NSString*) getValueForKey:(NSString*)aKey
{
    return [self getValueForKey:aKey andSubKey:nil];
}

- (NSDictionary*)getJsonData{
    NSError *jsonError;
    mJSONInfoString = [mMobileAPI collectInfo];
    NSData *objectData = [mJSONInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    return json;
}

- (NSString*) getValueForKey:(NSString*)aKey andSubKey:(NSString*)aSubkey
{
    NSUInteger adjrow = [mInfoItems indexOfObject:aKey];
    
    mJSONInfoString = [mMobileAPI collectInfo];
    
    if (!mJSONInfoString)
    {
        return @"";
    }
    
    NSData* jsonData = [mJSONInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* jsonError;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    
    NSString* data = @"Not supported or not collected";
    if(!json)
    {
        data = @"JSON Serialization error";
        NSLog(@"JSON error: %@", jsonError);
    }
    else
    {
        
        NSInteger index = adjrow;
        if([aKey isEqualToString:kRSASSID])
        {
            CFArrayRef myArray1 = CNCopySupportedInterfaces();
            if (myArray1) {
                CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray1, 0));
                NSDictionary *dict = (__bridge NSDictionary*)myDict;
                NSString* ssid = [dict objectForKey:@"SSID"];
                //fix for SSID is nil on 3G/4G interface
                if (ssid == nil) {
                    return @"";
                }
                else
                {
                    return ssid;
                }
            }
            else
                return @"";
        }
        else if ([[mJsonKeys objectAtIndex: index] isEqualToString:@"GeoLocationInfo"])
        {
            NSDictionary* geodata = nil;
            NSArray* locs = [json objectForKey: [mJsonKeys objectAtIndex: index]];
            if ( locs != nil) {
                geodata = [locs objectAtIndex: 0];
            }
            if (geodata == nil) {
                data = [self getDescription: nil];
            } else {
                if ([aSubkey isEqualToString:kRSASubkeyLatitude])
                {
                    data = (NSString*)[geodata objectForKey:aSubkey];
                }
                else if([aSubkey isEqualToString:kRSASubkeyLongitude])
                {
                    data = (NSString*)[geodata objectForKey:aSubkey];
                }
                else
                {
                    data = [self getLocationDescription: geodata];
                }
            }
        }
        else
        {
            NSObject* value = [json objectForKey: [mJsonKeys objectAtIndex: index]];
            NSString* desc = (value != nil) ? [NSString stringWithFormat: @"%@", value] : nil;
            data = [self getDescription: desc];
        }
    }
    
    if ([data rangeOfString:@"null"].location != NSNotFound || [data rangeOfString:@"Null"].location != NSNotFound || [data rangeOfString:@"NULL"].location != NSNotFound) {
        return @"";
    }
    else
    {
//        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
//        s = [s invertedSet];
//        data = [[data componentsSeparatedByCharactersInSet: s] componentsJoinedByString: @""];
        return data;
    }

}

-(NSString *)getDescription:(NSString *)data
{
    if(data != nil) {
        return data;
    }
    return @"";
    
}

-(NSString *)getLocationDescription: (NSDictionary*)geodata
{
    NSMutableString *buffer = [[NSMutableString alloc]initWithCapacity:256];
    for(NSString* s in mJsonLocationKeys) {
        NSString* value = [geodata objectForKey: s];
        if (value != nil) {
            [buffer appendString: [NSString stringWithFormat: @"%@:%@\n", s, value]];
        }
    }
    return buffer;
}
@end
