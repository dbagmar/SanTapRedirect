//
//  AcessToken.swift
//  Teclado
//
//  Created by Darshan Bagmar on 12/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation


struct AcessTokenServiceRequest{
    let data:String
}


struct AcessTokenModelResponse:Decodable {
    let access_token:String
    let scope:String
    let token_type:String
    let expires_in:Int
    
}
