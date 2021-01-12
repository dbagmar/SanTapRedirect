//
//  RegenrateURLModel.swift
//  Teclado
//
//  Created by Darshan Bagmar on 16/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

struct ReGenerateURLServiceRequestModelRequest:Codable {
    let deviceId:String
    let linkId:String
}

struct PaymentCancelModelResponse:Decodable {
    let code:String
    let desc:String
}
