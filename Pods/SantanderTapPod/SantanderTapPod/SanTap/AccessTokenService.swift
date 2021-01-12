//
//  AccessTokenService.swift
//  Teclado
//
//  Created by Darshan Bagmar on 13/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//


import Foundation
class AccessToken{
    
    
   static func getacessToken(signIN:SignInKeyboardModelResponse,_ completion: @escaping ((NetworkResult<AcessTokenModelResponse, ErrorResult>) -> Void)){
    let secret:String = signIN.body?.clientCredentials.password ?? " "
    let id:String = signIN.body?.clientCredentials.username ?? " "
        
        
        if secret != " " && id != " " {
            let strAcessToken:String  = "client_id=" + id + "&" + "client_secret=" + secret + "&" + "grant_type" + "client_credentials" + "scope" + "party-phone-inquiry_1.1.0"
                  
            self.getAcessTokenAPI(Data: strAcessToken){ result in
                   
                       switch result{
                               case .success(let Data):
                                       printLog(Data)
                                       completion(.success(Data))
                                       break
                                         
                       case .failure(let error) :
                                        printLog(error)
                                       completion(.failure(.parser(statusCode: 0, responseMessage: "token getting error")))
                                       break
                       }
               }
        }else{
            completion(.failure(.parser(statusCode: 0, responseMessage: "id password not found")))
        }
               
              
               
    }
    
    
    static  func getAcessTokenAPI(Data:String,_ completion: @escaping ((NetworkResult<AcessTokenModelResponse, ErrorResult>) -> Void))
    {
     
        let entityUrl:String = MAIN_URL + "token"
        
        
        networkRequestWith(entity: entityUrl, action: POST_ACTION, queryParameters: nil,reqBody: Data, isTokenRequired: false) { dataResult in
            
            switch dataResult {
                
            case .success(let data) :
                
                            if let decodedData = try? JSONDecoder().decode(AcessTokenModelResponse.self, from: data)
                            {
                                completion(.success(decodedData))
                               break
                            }
                
                
            case .failure(let error) :
                printLog("Network error \(error)")
                completion(.failure(.parser(statusCode: 0, responseMessage: "data parser error")))
                break
            }
            
        }
        
    }

}
