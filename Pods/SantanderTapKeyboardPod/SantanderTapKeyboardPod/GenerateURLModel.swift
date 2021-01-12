//
//  GenerateURLModelResponse.swift
//  Teclado
//
//  Created by Darshan Bagmar on 12/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

struct GenerateURLServiceRequest:Encodable {
    let deviceId:String
    let amount:String
    let softToken:String
}


struct urlBody:Decodable{
    let link:String
    let message:String
    let linkPassword:String
}
struct GenerateURLModelResponse:Decodable {
    let code: String
    let desc: String
    let body:urlBody?
}


