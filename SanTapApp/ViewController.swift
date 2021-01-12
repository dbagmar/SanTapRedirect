//
//  ViewController.swift
//  SantanderTap
//
//  Created by Pranjal Lamba on 18/02/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    
    @IBAction func openSettings(_ sender: Any) {
       /* if let url = URL(string: UIApplication.openSettingsURLString) {
            // If general location settings are enabled then open location settings for the app
            UIApplication.shared.open(url)
        }*/
        
        let appURLScheme = "SampleApp:"
        guard let appURL = URL(string: appURLScheme) else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            }else {
                UIApplication.shared.openURL(appURL)
            }
        }else {
             UIApplication.shared.open(appURL)
        }

    }
    
    func textViewDidChange(_ textView: UITextView) {
//        printLog(textView.text!)
    }
}

