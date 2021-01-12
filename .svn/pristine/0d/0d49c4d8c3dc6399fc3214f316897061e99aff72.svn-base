//
//  CreateURLViewController.swift
//  SanTap
//
//  Created by Darshan Bagmar on 22/05/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit
import Messages

protocol CreateURLViewControllerDelegate: class {
    func addURLMessage(_ item: Message, layoutImg: UIImage?)
}

class CreateURLViewController: UIViewController {
    static let storyboardIdentifier = "CreateURLViewController"
    var conversation: MSConversation?
    @IBOutlet weak var mainView: UIView!
    var delegate:CreateURLViewControllerDelegate?
    var message:Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
   
    
   
    
    @IBAction func doneBtnClick(_ sender: Any) {
       let message = Message.init(msgCaption: "payment Completed", msgImage: UIImage(named: "SubmitButton")!, msgURL: "payment Completed", msgDescription: "payment Completed")
            
        self.delegate?.addURLMessage(message, layoutImg: self.createLayoutImage())
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


extension CreateURLViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          return textField.resignFirstResponder()
      }
}


extension CreateURLViewController{
    func createLayoutImage()->UIImage?{
        let size = CGSize(width:self.view.bounds.width, height: self.mainView.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


