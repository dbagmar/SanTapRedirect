//
//  RSAMobileSDK.h
//  SmeUsa
//
//  Created by Rafael Maiquez on 20/8/15.
//  Copyright (c) 2015 talentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRSAMobileSDKVersion @"Mobile SDK Version"
#define kRSAHardwareID @"Hardware ID"
#define kRSASIMID @"SIM ID"
#define kRSAPhoneNumber @"Phone Number"
#define kRSAGeoLocationData @"Geo-location Data"
#define kRSADeviceModel @"Device model"
#define kRSADeviceMultitaskingSupported @"Device multitasking supported"
#define kRSADeviceName @"Device Name"
#define kRSADeviceSystemName @"Device System Name"
#define kRSADeviceSystemVersion @"Device System Version"
#define kRSALanguages @"Languages"
#define kRSAWIFIMAC @"Wi-Fi MAC Address"
#define kRSAWIFINetworks @"Wi-Fi Networks data"
#define kRSACellTowerID @"Cell Tower ID"
#define kRSALocationAreaCode @"Location area code"
#define kRSAScreenSize @"Screen size"
#define kRSAApplicationKey @"RSA Application key"
#define kRSAMCC @"MCC"
#define kRSAMNC @"MNC"
#define kRSAOSID @"OS ID"
#define kRSACompromised @"Compromised"
#define kRSAEmulator @"Emulator"
#define kRSASSID @"SSID"
#define kRSATimeStamp @"TimeStamp"
#define kRSACustomDecimal @"CustomDecimal"
#define kRSACustomInteger @"CustomInteger"
#define kRSACustomString @"CustomString"
#define kRSACustomBool @"CustomBool"

#define kRSASubkeyLatitude @"Latitude"
#define kRSASubkeyLongitude @"Longitude"
#define kRSAAdvertiserID @"AdvertiserId"

@class MobileAPI;

@interface RSAMobileSDK : NSObject{
@private
    NSArray *mInfoItems;
    NSArray *mJsonKeys;
    
    NSArray *mJsonLocationKeys;
    NSString *mJSONInfoString;
    MobileAPI *mMobileAPI;
    BOOL mMobileAPIInitialized;
   
    int mConfiguration;
}


+ (RSAMobileSDK *)sharedInstance;

- (NSString*) getValueForKey:(NSString*)aKey;
- (NSString*) getValueForKey:(NSString*)aKey andSubKey:(NSString*)aSubkey;
- (NSDictionary*)getJsonData;
@end
