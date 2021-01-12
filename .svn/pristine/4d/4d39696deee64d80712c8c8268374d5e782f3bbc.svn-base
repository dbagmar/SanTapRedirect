//
//  SignInKeyBoard.swift
//  Teclado
//
//  Created by Darshan Bagmar on 12/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation


struct SignInKeyboardsServiceRequest {
    let data:String
}

struct authToken {
    let token:String
}

struct clientCredentials:Decodable{
    let username:String
    let password:String
}
struct infoClient:Decodable{
    let minAmount:Double
    let amountAvailable:Double
    let tipoToken:String
    let isDailyAvailable:Bool
}
struct body:Decodable {
    let infoClient:infoClient
    let clientCredentials:clientCredentials
}
struct SignInKeyboardModelResponse:Decodable {
    let code:String
    let desc:String
    let body:body?
}


