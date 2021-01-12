//
//  MessagesViewController.swift
//  TecladoiMessage
//
//  Created by Darshan Bagmar on 19/05/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

/*import UIKit
import Messages
import SantanderTapPod

class MessagesViewController: MessagesParentViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
}*/

import UIKit
import Messages
import SantanderTapPod
//MSMessagesAppViewController
class MessagesViewController: MessagesParentViewController {


override func viewDidLoad() {
super.viewDidLoad()
    if let userDefaults = UserDefaults(suiteName: "group.com.idmission.santap") {
        if userDefaults.string(forKey: "SanTap_URL") == nil {
            UserDefaults.standard.set("DEV2", forKey: "URL")
        }else{
            let urlFor = userDefaults.string(forKey: "SanTap_URL")
            UserDefaults.standard.set(urlFor, forKey: "URL")
        }
        
       
    }
}

override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
}
}




