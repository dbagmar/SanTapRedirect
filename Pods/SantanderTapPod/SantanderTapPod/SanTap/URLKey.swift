//
//  URLKey.swift
//  SantanderTapPod
//
//  Created by Darshan Bagmar on 06/09/20.
//  Copyright © 2020 Darshan Bagmar. All rights reserved.
//

import Foundation

struct fetchApiKEy: Encodable,Decodable {
    let keySslPinning: String?
   
    
    enum CodingKeys: String, CodingKey {
        case keySslPinning = "keySslPinning"
    }
}

class URLKey{
    static func getURLKey(_ completion: @escaping ((NetworkResult<fetchApiKEy, ErrorResult>) -> Void))
    {
        let entityUrl:String = MAIN_URL+"security/keys/"+urlKey
        networkRequestWith(entity: entityUrl, action: GET_ACTION, queryParameters: nil,reqBody: "", isTokenRequired: false) { dataResult in
            switch dataResult {
            case .success(let data) :
                let results = String(data: data, encoding: .utf8) ?? ""
                if let publicKey = try? JSONDecoder().decode(fetchApiKEy.self, from: results.data(using: .utf8)!){
                    printLog("\(results)")
                    if (publicKey.keySslPinning != " " )
                                   {
                                    completion(.success(publicKey))
                                       return
                                   }else{
                                       completion(.failure(.parser(statusCode: 0, responseMessage: "public key not found")))
                                       return
                                   }
                }else{
                    completion(.failure(.parser(statusCode: 0, responseMessage: "public key parser error")))
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

