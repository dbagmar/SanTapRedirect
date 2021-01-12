//
//  HistoricURLModel.swift
//  Teclado
//
//  Created by Darshan Bagmar on 12/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation


struct PaymentHistoryServiceRequest:Encodable {
    let deviceId:String
    let initDate:String
    let finishDate:String
}

struct History:Decodable {
    let url:String
    let amount:String
    let date:String
    let status:String
    let ref:String
    let beneficiary:String
    let id:String
}


struct PaymentHistoryModelResponse:Decodable {
    let code:String
    let desc:String
    let body:HistoryBody
    
    struct HistoryBody:Decodable {
        let links:[History]
    }
}

