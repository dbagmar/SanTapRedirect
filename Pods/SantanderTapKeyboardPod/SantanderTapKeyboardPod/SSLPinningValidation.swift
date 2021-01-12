//
//  SSLPinningValidation.swift
//  SantanderTapKeyboardPod
//
//  Created by Darshan Bagmar on 25/08/20.
//  Copyright © 2020 Darshan Bagmar. All rights reserved.
//

import Foundation
import Security
import CommonCrypto

class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    let defaults = UserDefaults.standard
    var publicKeyHash:String?
    static var urlPublicHash:String!
    
       let rsa2048Asn1Header:[UInt8] = [
           0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
           0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
       ]
       
       private func sha256(data : Data) -> String {
           var keyWithHeader = Data(rsa2048Asn1Header)
           keyWithHeader.append(data)
           var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
           
           keyWithHeader.withUnsafeBytes {
               _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
           }
           
           
           return Data(hash).base64EncodedString()
       }
    
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let keyData:String = defaults.value(forKey: "URL") as? String ?? Dev
        publicKeyHash = defaults.value(forKey: SSLPinKey) as? String
        
       /* switch keyData {
        case Dev: publicKeyHash = defaults.value(forKey: DevKey) as? String
            break
        case Pre:publicKeyHash = defaults.value(forKey: PreKey) as? String
            break
        case Prod:publicKeyHash = defaults.value(forKey: ProdKey) as? String
            break
        case Dev2:publicKeyHash = defaults.value(forKey: DevKey) as? String
        break
        default:publicKeyHash = defaults.value(forKey: PreKey) as? String
            break
        }*/
        
        NSURLSessionPinningDelegate.urlPublicHash = publicKeyHash
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return
        }
            if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                // Server public key
                var serverPublicKey:SecKey!
                if #available(iOS 12.0, *) {
                    serverPublicKey = SecCertificateCopyKey(serverCertificate)
                } else {
                    serverPublicKey = SecCertificateCopyPublicKey(serverCertificate)
                }
                let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil )!
                let data:Data = serverPublicKeyData as Data
                // Server Hash key
                let serverHashKey = sha256(data: data)
                // Local Hash Key
                let publickKeyLocal = type(of: self).urlPublicHash
                if (serverHashKey == publickKeyLocal) {
                    // Success! This is our server
                    printLog("Public key pinning is successfully completed")
                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                    return
                }
            }else{
                 completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            }
    }
    
  

}



