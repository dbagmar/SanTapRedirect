//
//  GenerateURLServiceRequest.swift
//  Teclado
//
//  Created by Darshan Bagmar on 12/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

class GeneratePaymentURL{
    
    
    static func getURL(genrateURLSErvice:GenerateURLServiceRequest,skk:String,authoriztion:String,authToken:String,_ completion: @escaping ((NetworkResult<GenerateURLModelResponse, ErrorResult>) -> Void)){
        
       // let key = genrateURLSErvice
        let encoded = try! JSONEncoder().encode(genrateURLSErvice)
        let encodedStr = AppUtility.jsonString(json: encoded)
                   
        let encrypDict = AESEncryptionss.AESEncryption(value: encodedStr, skkStr: skk)
        
        
        let getUrlServiceKey = AESEncryptionModel.init(key: encrypDict)
        
        self.getPaymentURL(data: getUrlServiceKey,RSA:skk,authoriztion: authoriztion, authToken: authToken){
            urlresult in
            switch urlresult{
            case .success(let aesData):

                let decodedString = AESEncryptionss.AesDecrypt(skkStr: skk, encodesString:aesData.key)
                   if let decodedData = try? JSONDecoder().decode([GenerateURLModelResponse].self, from: decodedString.data(using: .utf8)!)
                   {
                       completion(.success(decodedData.first!))
                       break
                   }else{
                       completion(.failure(.parser(statusCode: 0, responseMessage: "sign in data not found")))
                       break
                   }
               
            case .failure(let error):
                printLog(error)
                completion(.failure(.parser(statusCode: 0, responseMessage: "data parser error")))
                break
            }
        }
        
        
    }
    
    
    static func getPaymentURL(data:AESEncryptionModel,RSA:String,authoriztion:String,authToken:String,_ completion: @escaping ((NetworkResult<AESDecryptionService, ErrorResult>) -> Void))
    {
     
        
        let entityUrl:String = MAIN_URL + "security/links"
        
        let httpHeader:[String:String] = ["T-Location":device.location,
                                          "T-Device-Model":device.deviceName,
                                          "T-Os":device.systemVersion,"T-Os-Version":device.iOS,
                                          "X-Auth-Token":authoriztion,
                                          "Authorization":authToken]
                                          //"Cookie":"JSESSIONID=75FF5EF1ED8510E7DC0CD995E7259949"]
        
        
        networkRequestWith(entity: entityUrl, action: POST_ACTION, queryParameters: nil,reqBody: data.key, httpHeaders: httpHeader,isTokenRequired: false) { dataResult in
            
            switch dataResult {
                
            case .success(let data) :
                            let results = String(data: data, encoding: .utf8) ?? ""
                            let aesDec = AESDecryptionService.init(key: results)
                            completion(.success(aesDec))
                            break
                    
            
            case .failure(let error) :
                printLog("Network error \(error)")
                completion(.failure(.parser(statusCode: 0, responseMessage: "data parser error")))
                break
            }
            
        }
        
    }
    
   
    
    
   
    
    
    
}
