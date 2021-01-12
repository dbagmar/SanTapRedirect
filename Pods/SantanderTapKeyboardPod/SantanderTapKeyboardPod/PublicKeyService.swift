//
//  PublicKeyService.swift
//  Teclado
//
//  Created by Darshan Bagmar on 12/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
class PublicKey{
    static func getPublicKey(_ completion: @escaping ((NetworkResult<PublicModelResponse, ErrorResult>) -> Void))
    {
        let entityUrl:String = MAIN_URL+"security/pub_tap_key"
        networkRequestWith(entity: entityUrl, action: GET_ACTION, queryParameters: nil,reqBody: "", isTokenRequired: false) { dataResult in
            switch dataResult {
            case .success(let data) :
                let results = String(data: data, encoding: .utf8) ?? ""
                let publicKey = PublicModelResponse.init(Data: results)
                printLog("\(results)")
                if (publicKey.Data != " ")
                {
                    completion(.success(publicKey))
                    return
                }else{
                    completion(.failure(.parser(statusCode: 0, responseMessage: "public key not found")))
                    return
                }
            case .failure(let error) :
                printLog("Network error \(error)")
                completion(.failure(.parser(statusCode: 0, responseMessage: "public key parser error")))
                return
            }
        }
    }
}
