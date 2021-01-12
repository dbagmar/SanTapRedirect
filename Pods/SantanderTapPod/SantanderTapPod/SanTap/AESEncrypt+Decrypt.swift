//
//  AESEncrypt+Decrypt.swift
//  Teclado
//
//  Created by Darshan Bagmar on 11/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
import CommonCrypto

class AESEncryptionss{
    
        
    static func AESEncryption(value: String,skkStr:String) -> Data {
           
        let skk:String? = skkStr
        var llave: Array<UInt8>?;
        var aes: AES?;
            
            do {
              
                printLog(value)
                let start = skk!.startIndex
                let end = skk!.index(skk!.endIndex, offsetBy: -16)
                let end2 = skk!.index(skk!.endIndex, offsetBy: 0)
                let key = skk![start..<end]
                let initVector = skk![end..<end2]
                
                printLog("password: ",key)
                printLog("salt: ",initVector)
                
                let password: Array<UInt8> = Array(key.utf8)
                let salt: Array<UInt8> = Array(initVector.utf8)
                
                llave = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 1000, keyLength: 32, variant: .sha256).calculate()
                
                aes = try AES(key: llave!, blockMode: CBC(iv: salt), padding: .pkcs5)
                
                
                let textEncrypt = try aes!.encrypt(value.bytes)
                
                let base64Decoded2 = Data(textEncrypt)
                
                let encryptStr = base64Decoded2.base64EncodedString().data(using: .utf8)
                
                return encryptStr ?? Data.init()
                
            } catch {
                    printLog("Failed")
                    printLog(error)
                    return Data.init()
                   }
        }
        
    

    
    static func AesDecrypt(data:Data=Data.init(),skkStr:String,encodesString:String) -> String {
        let skk:String? = skkStr
        var llave: Array<UInt8>?;
        var aes: AES?;
            
            do {
                
                let start = skk!.startIndex
                //printLog(start)
                let end = skk!.index(skk!.endIndex, offsetBy: -16)
                let end2 = skk!.index(skk!.endIndex, offsetBy: 0)
                let key = skk![start..<end]
                let initVector = skk![end..<end2]
                
                printLog("password: ",key)
                printLog("salt: ",initVector)
                
                let password: Array<UInt8> = Array(key.utf8)
                let salt: Array<UInt8> = Array(initVector.utf8)
                
                llave = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 1000, keyLength: 32, variant: .sha256).calculate()
                
                aes = try AES(key: llave!, blockMode: CBC(iv: salt), padding: .pkcs5)
                
                let str = encodesString
                  
                var decodedData = data
                if str != " " {
                    let cipherText = str.replacingOccurrences(of: "\"", with: "")
                    decodedData = Data(base64Encoded: cipherText)!
                }
                
                let text = try aes!.decrypt(decodedData.bytes)
                
                printLog(text.toBase64()!)
                
                let base64Decoded = Data(base64Encoded: text.toBase64()!)!
                
                var decodedString = String(data: base64Decoded, encoding: .utf8)!
                
                decodedString = "["+decodedString+"]"
                
                printLog(decodedString)
                return decodedString

            } catch {
                    printLog("Failed")
                    printLog(error)
                    return "failed"
                   }
            
            
        }
    
    
    
    
}
