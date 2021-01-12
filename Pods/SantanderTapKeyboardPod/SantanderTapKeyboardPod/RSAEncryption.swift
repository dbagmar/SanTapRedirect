//
//  RSAEncryption.swift
//  Teclado
//
//  Created by Darshan Bagmar on 11/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
import Security

struct RSA {

static func encrypt(string: String, publicKey: String?) -> String? {
    guard let publicKey = publicKey else { return nil }

    let keyString = publicKey
    guard let data = Data(base64Encoded: keyString) else { return nil }

    var attributes: CFDictionary {
        return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                kSecAttrKeySizeInBits   : 4096,
                kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
    }

    var error: Unmanaged<CFError>? = nil
    guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
        printLog(error.debugDescription)
        return nil
    }
    return encrypt(string: string, publicKey: secKey)
}

static func encrypt(string: String, publicKey: SecKey) -> String? {
    let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
    let plainData = string.data(using: .utf8)
    let data = SecKeyCreateEncryptedData(
        publicKey,
        .rsaEncryptionOAEPSHA256,
        plainData! as CFData,error) as! Data
    return data.base64EncodedString()
    }
}

