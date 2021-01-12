//
//  GenrateRandomKey.swift
//  Teclado
//
//  Created by Darshan Bagmar on 13/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

class RandomKey{
    
    /*
        The function generates a random base64 string of 96 characteres,
        Use of the safe and random generation of characters.
     */
    func generateRandomBytes() -> String? {

        var keyData = Data(count: 72)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 72, $0.baseAddress!)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            printLog("Problem generating random bytes")
            return nil
        }
    }
    
    func randomCharString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func randomNumString(length: Int) -> String {
        // let num = " "//RSAMobileSDK().getValueForKey(kRSAPhoneNumber) ?? " "
        //let letters = "0123456789"
        //return String((0..<length).map{ _ in letters.randomElement()! })
        //return "03353cc6-aaf8-4c22-a1af-49e8f6f603A05"
        return "9EE78A47-FB1A-480D-ADDA-50FDF92E1986"
        //MARK:- signin request error
        //return "191CD3C1-5248-4D91-BB39-33D30E2F7866"
        //return "191CD3C1-5248-4D91-BB39-33D30E2F7867"
      // return "191CD3C1-5248-4D91-BB39-33D30E2F7868"
        // return "191CD3C1-5248-4D91-BB39-33D30E2F7869"
        // return "191CD3C1-5248-4D91-BB39-33D30E2F786A"
        //MARK:- Amount view validation
        //return "191CD3C1-5248-4D91-BB39-33D30E2F7860"
        // return "191CD3C1-5248-4D91-BB39-33D30E2F7861"
         //return "191CD3C1-5248-4D91-BB39-33D30E2F7862"
        // return "191CD3C1-5248-4D91-BB39-33D30E2F7863"
        // return "191CD3C1-5248-4D91-BB39-33D30E2F7864"
        // return "191CD3C1-5248-4D91-BB39-33D30E2F7865"
        
    }
    
    func getDeviceId(length: Int) -> String {
           let deviceData = PWDeviceData()
           var deviceId = deviceData.hardwareId
           
           //RSASDK not work in Simulator
           if deviceId == "" {
              // deviceId = "03353cc6-aaf8-4c22-a1af-49e8f6f603A05"
            deviceId = "9EE78A47-FB1A-480D-ADDA-50FDF92E1986"
           }
           printLog("device id --->\(deviceId)")
           return deviceId
           
       }
}
