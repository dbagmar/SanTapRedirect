//
//  AlertViewController.swift
//  Teclado
//
//  Created by Darshan Bagmar on 27/05/20.
//  Copyright © 2020 Darshan Bagmar. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var alertLabel: UILabel!
    var urlStr:String?
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if urlStr?.contains("www.santander.com") ?? false{
            alertLabel.text = "Estás por ingresar a" + "\n" + "www.santander.com." + "\n" + "En caso que desees continuar" + "\n" + "se cerrará tu sesión."
        }else{
            alertLabel.text = "Estás por ingresar a una página cuya" + "\n" + "seguridad no depende ni es" + "\n" + "responsabilidad de Santander." + "\n" + "En caso que desees continuar" + "\n" + "se cerrará tu sesión."
        }
        
        
        alertView.layer.borderColor = (UIColor(hexString: "#000000")).cgColor //AppUtility.hexStringToUIColor(hex: "cdcdcd").cgColor
        alertView.layer.borderWidth = 1
        
        
        
        // Do any additional setup after loading the view.
    }


    @IBAction func onClickCancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func onClickSitio(_ sender: Any) {
    
    let url = NSURL(string:urlStr ?? " ")
    let context = NSExtensionContext()
    context.open(url! as URL, completionHandler: nil)

    var responder = self as UIResponder?
    while (responder != nil){
        if responder?.responds(to: Selector("openURL:")) == true{
            responder?.perform(Selector("openURL:"), with: url)
        }
        responder = responder!.next
    }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
