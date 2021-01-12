//
//  Message.swift
//  TecladoiMessage
//
//  Created by Darshan Bagmar on 20/05/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
import UIKit
import Messages

struct Message{
    var msgCaption:String?
    var msgImage:UIImage?
    var msgURL:String?
    var msgDescription:String?
    init(msgCaption:String,msgImage:UIImage,msgURL:String,msgDescription:String) {
        self.msgCaption = msgCaption
        self.msgImage = msgImage
        self.msgURL = msgURL
        self.msgDescription = msgDescription
    }
    
    init?(message: MSMessage?){
        guard let url = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        //self.init(msgCaption:String,msgImage:UIImage,msgURL:String,msgDescription:String)
    }
}
