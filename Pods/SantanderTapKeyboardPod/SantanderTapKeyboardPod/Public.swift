//
//  Public.swift
//  Teclado
//
//  Created by Darshan Bagmar on 11/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

struct PublicModelResponse{
    let Data:String
}



struct fetchApiKEy: Encodable,Decodable {
    let keySslPinning: String?
   
    
    enum CodingKeys: String, CodingKey {
        case keySslPinning = "keySslPinning"
    }
}
