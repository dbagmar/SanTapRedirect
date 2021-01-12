//
//  AcessCheckAlertViewController.swift
//  SantanderTapKeyboardPod
//
//  Created by Darshan Bagmar on 17/07/20.
//  Copyright © 2020 Darshan Bagmar. All rights reserved.
//

import UIKit

class AcessCheckAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onAbrirAjustesButtonClick(_ sender: Any) {
    
        if let url = URL(string: UIApplication.openSettingsURLString) {
                   // If general location settings are enabled then open location settings for the app
                   //UIApplication.shared.open(url)
            let context = NSExtensionContext()
            context.open(url as URL, completionHandler: nil)

            var responder = self as UIResponder?
            while (responder != nil){
                if responder?.responds(to: Selector("openURL:")) == true{
                    responder?.perform(Selector("openURL:"), with: url)
                }
                responder = responder!.next
                }
        }
    
    }
    
}
