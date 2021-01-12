//
//  PWDeviceData.swift
//  SantanderTap
//
//  Created by MacPro on 26/05/20.
//  Copyright © 2020 jvmv. All rights reserved.
//

import UIKit
//import SwiftKeychainWrapper

let kHardwareIDKeychainKEY = "HardwareID_KCK"

let kHardWareIDKey = "HardwareID"
let kTimestampKey = "TIMESTAMP"
let kDeviceModelKey = "DeviceModel"
let kLanguagesKey = "Languages"
let kMCCKey = "MCC"
let kDeviceSystemVersionKey = "DeviceSystemVersion"
let kDeviceNameKey = "DeviceName"
let kGeoLocationInfoKey = "GeoLocationInfo"
let kWiFiNetworkDataKey = "WiFiNetworksData"
let kMNCKey = "MNC"
let kMultiTaskingSupportedKey = "MultitaskingSupported"
let kScreenSizeKey = "ScreenSize"
let kDeviceSystemNameKey = "DeviceSystemName"
let kRSAApplicationKey = "RSA_ApplicationKey"
let kSDKVersionKey = "SDK_VERSION"
let kOSIDKey = "OS_ID"

let kRSASDKKey = "DFECE99E093D63820606E903E3C9E217"

class PWDeviceData: PWBaseModel
{
    // MARK: Getter setter methods
    
    var hardwareId: String
    {
        get {
            
            let hID = RSAMobileSDK.sharedInstance().getValueForKey(kRSAHardwareID)
            let cypheredStr = CryptoHelper.cypherString(str: hID!)
            KeychainWrapper.standard.set(cypheredStr, forKey: kHardwareIDKeychainKEY, withAccessibility: .whenUnlocked)
            return hID!
        }
        set
        {
            KeychainWrapper.standard.set(newValue, forKey: kHardwareIDKeychainKEY, withAccessibility: .whenUnlocked)
        }
    }
 
    // MARK: Public method overrides
    
    override func dictionaryRepresentation()->Dictionary<String,AnyObject>
    {
        var dicc = Dictionary<String,AnyObject>()
        #if (arch(i386) || arch(x86_64)) && os(tvOS)
            dicc[kHardWareIDKey] = ""
            dicc[kTimestampKey] = ""
            dicc[kDeviceModelKey] = ""
            dicc[kLanguagesKey] = ""
            dicc[kMCCKey] = ""
            dicc[kDeviceSystemVersionKey] = ""
            dicc[kDeviceNameKey] = ""
            dicc[kGeoLocationInfoKey] = ""
            dicc[kWiFiNetworkDataKey] = ""
            dicc[kMNCKey] = ""
            dicc[kMultiTaskingSupportedKey] = ""
            dicc[kScreenSizeKey] = ""
            dicc[kDeviceSystemNameKey] = ""
            dicc[kRSAApplicationKey] = ""
            dicc[kSDKVersionKey] = ""
            dicc[kOSIDKey] = ""
        #else
            let rsaInstance = RSAMobileSDK.sharedInstance()
            dicc[kHardWareIDKey] = self.hardwareId as AnyObject?
            dicc[kTimestampKey] = rsaInstance?.getValueForKey(kRSATimeStamp).replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "T", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "Z", with: "") as AnyObject
            dicc[kDeviceModelKey] = rsaInstance?.getValueForKey(kRSADeviceModel) as AnyObject
            dicc[kLanguagesKey] = rsaInstance?.getValueForKey(kRSALanguages) as AnyObject
            dicc[kMCCKey] = rsaInstance?.getValueForKey(kRSAMCC) as AnyObject
            dicc[kDeviceSystemVersionKey] = rsaInstance?.getValueForKey(kRSADeviceSystemVersion) as AnyObject
            dicc[kDeviceNameKey] = rsaInstance?.getValueForKey(kRSADeviceName) as AnyObject
            dicc[kGeoLocationInfoKey] = rsaInstance?.getValueForKey(kRSAGeoLocationData) as  AnyObject
            dicc[kWiFiNetworkDataKey] = rsaInstance?.getValueForKey(kRSAWIFINetworks) as AnyObject
            dicc[kMNCKey] = rsaInstance?.getValueForKey(kRSAMNC) as AnyObject
            dicc[kMultiTaskingSupportedKey] = rsaInstance?.getValueForKey(kRSADeviceMultitaskingSupported) as AnyObject
            dicc[kScreenSizeKey] = rsaInstance?.getValueForKey(kRSAScreenSize) as AnyObject
            dicc[kDeviceSystemNameKey] = rsaInstance?.getValueForKey(kRSADeviceSystemName) as AnyObject
            dicc[kRSAApplicationKey] = kRSASDKKey as AnyObject
            dicc[kSDKVersionKey] = rsaInstance?.getValueForKey(kRSAMobileSDKVersion) as AnyObject
            dicc[kOSIDKey] = rsaInstance?.getValueForKey(kRSAOSID) as AnyObject
            
//            dicc[kHardWareIDKey] = "" as AnyObject
//            dicc[kTimestampKey] = "" as AnyObject
//            dicc[kDeviceModelKey] = "" as AnyObject
//            dicc[kLanguagesKey] = "" as AnyObject
//            dicc[kMCCKey] = "" as AnyObject
//            dicc[kDeviceSystemVersionKey] = "" as AnyObject
//            dicc[kDeviceNameKey] = "" as AnyObject
//            dicc[kGeoLocationInfoKey] = "" as AnyObject
//            dicc[kWiFiNetworkDataKey] = "" as AnyObject
//            dicc[kMNCKey] = "" as AnyObject
//            dicc[kMultiTaskingSupportedKey] = "" as AnyObject
//            dicc[kScreenSizeKey] = "" as AnyObject
//            dicc[kDeviceSystemNameKey] = "" as AnyObject
//            dicc[kRSAApplicationKey] = "" as AnyObject
//            dicc[kSDKVersionKey] = "" as AnyObject
//            dicc[kOSIDKey] = "" as AnyObject

            
        #endif
        return dicc

    }

}
