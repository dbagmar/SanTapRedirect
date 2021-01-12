//
//  CryptoHelper.swift
//  SantanderTap2.0
//
//  Created by MacPro on 26/05/20.
//  Copyright © 2020 jvmv. All rights reserved.
//

import UIKit

let kIVStoreKey = "DEPUL_STORE"

class CryptoHelper: NSObject {
    
    // MARK: Public Methods
    
    static func cypherString(str:String)->Data
    {
        let selectedAlgorithm: SymmetricCryptorAlgorithm = .aes_256
        let deviceId = CryptoHelper.getCypherKey()
        let key = SymmetricCryptor.keyfLength(selectedAlgorithm.requiredKeySize(),initialString:deviceId)
        let options = kCCOptionPKCS7Padding
        let cypher = SymmetricCryptor(algorithm: selectedAlgorithm, options: options)
        cypher.setIVBasedOn(initialString: deviceId)
        do {
            let cypherText = try cypher.crypt(string: str, key: key) as Data
            /*
            if let cypheredString = String(data: cypherText, encoding: String.Encoding.utf8) {
                print("Cypher String. Original: \(str), Result: \(cypheredString)")
                return cypherText
            } else {
                let cypheredString = cypherText.hexDescription
                print("Cypher String. Original: \(str), Result: \(cypheredString)")
                return cypherText
            }
            */
            return cypherText
        } catch {
            //print("Error cyphering data: \(str)")
            return Data()
        }
    }
    
    static func decypherString(str:Data)->String
    {
        let deviceId = CryptoHelper.getCypherKey()
        let selectedAlgorithm: SymmetricCryptorAlgorithm = .aes_256
        let key = SymmetricCryptor.keyfLength(selectedAlgorithm.requiredKeySize(),initialString:deviceId)
        let options = kCCOptionPKCS7Padding
        let cypher = SymmetricCryptor(algorithm: selectedAlgorithm, options: options)
        let cypheredString = str.toHexString()
        cypher.setIVBasedOn(initialString: deviceId)
        do {
            let clearData = try cypher.decrypt(str, key: key)
            if let clearDataAsString = String(data: clearData, encoding: String.Encoding.utf8)
            {
                //print("Decypher String. Original: \(cypheredString), Result: \(clearDataAsString)")
                return clearDataAsString
            }
            else
            {
                //print("Error decyphering data: \(cypheredString)")
                return cypheredString
            }
        } catch {
            //print("Error decyphering data: \(cypheredString)")
            return cypheredString
        }
    }
    
    // MARK: Private Methods
    
    private static func getCypherKey()->String
    {
        let deviceId = UIDevice.current.identifierForVendor
        let dev = (deviceId?.uuidString)!.sha256()
        return dev
    }
    
    

}
