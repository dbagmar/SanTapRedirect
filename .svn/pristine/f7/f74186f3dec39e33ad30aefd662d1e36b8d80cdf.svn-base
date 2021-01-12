//
//  KeyboardActionInputViewController.swift
//  Teclado
//
//  Created by Darshan Bagmar on 05/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

class KeyboardActionInputViewController: UIInputViewController {
    @IBOutlet weak var mainKeyboardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        //view.addSubview(mainKeyboardView)
        keyboardActionHandler = DemoKeyboardActionHandler(inputViewController: self)
        // Do any additional setup after loading the view.
    }

    
    
    open lazy var keyboardActionHandler: KeyboardActionHandler = {
        StandardKeyboardActionHandler(inputViewController: self)
    }()

    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       view.addSubview(mainKeyboardView)
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
