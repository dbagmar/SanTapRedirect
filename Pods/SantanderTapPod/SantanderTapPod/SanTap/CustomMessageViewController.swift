//
//  CustomMessageViewController.swift
//  Teclado
//
//  Created by Darshan Bagmar on 31/03/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

protocol CustomMessageViewControllerDelegate: class {
    func setMessageUi(setMessageUi:Bool)
    func addURLMessage(_ item: GenerateURLModelResponse, layoutImg: UIImage?)
}


var amountPagar = " "
class CustomMessageViewController: UIViewController,UITextFieldDelegate {
    
    weak var delegate:CustomMessageViewControllerDelegate?
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet var messageUiView: UIView!
    @IBOutlet var uiviewForMsg: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var dynamicAmountPicker: UIPickerView!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet var numericView: UIView!
    @IBOutlet weak var amountTextfield: UITextField!
    
    @IBOutlet var amountView: UIView!
    @IBOutlet weak var amountShowView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet var passwordView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet var sentView: UIView!
    @IBOutlet weak var finalAmountLabel: UILabel!
    
    @IBOutlet var progressView: UIView!
    @IBOutlet weak var fixAmountValiationLabel: UILabel!
    @IBOutlet weak var manualAmountValidationLabel: UILabel!

    @IBOutlet var timerAlertView: UIView!
    @IBOutlet weak var amountShowingLabel: UILabel!
    @IBOutlet weak var messageShowingLabel: UILabel!
    
    @IBOutlet var messageFinalScreen: UIView!
    
    @IBOutlet var superMovilAlertView: UIView!
    
    
    @IBOutlet weak var msgLabelTextfield: UITextField!
    @IBOutlet weak var msgLabelText2field: UITextField!
    @IBOutlet weak var msgLabelText3Field: UITextField!
    @IBOutlet weak var deviceIdLabel: UILabel!
    
    @IBOutlet weak var textImageView: UIImageView!
    var buttonView:UIView?
    var fixValue:Bool?
    var progressFlag:Bool?
    var screenTimer: Timer?
    var alertTimer: Timer?
    let screenTime = 50.0

    var count = 0
    var signIn:SignInKeyboardModelResponse?
    var rsaKey:RSAEncryptionService?
    var arrofValue:[String]? = ["20","50","100","200","500","1000","2000"]
    var amount:String = "0.00"
    var pickerViewAmount:String = "0.00"
    var password:String = ""
    var passwordValue:String = ""
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
        printLog("CustomMessageViewController is deallocated")
    }
    // MARK:- ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAmountPicker.dataSource = self
        dynamicAmountPicker.delegate = self
        amountTextfield.delegate = self
        progressFlag = false
        passwordTextfield.isUserInteractionEnabled = false
        amountTextfield.isUserInteractionEnabled = false
       // buttonStackView.addArrangedSubview(buttonView!)
        pickerView.show()
        progressView.frame = pickerView.bounds
        dynamicAmountPicker.selectRow(0, inComponent: 0, animated: true)
        amount = arrofValue?[0] ?? "0.0"
        finalAmountLabel.attributedText = NSMutableAttributedString().normal("Enviaste ", fontSizes: 30).bold("$", fontSizes: 30).bold(amountPagar, fontSizes: 30)
        versionLabel.text = "v" + (Bundle.main.releaseVersionNumber ?? " ") + "." + (Bundle.main.buildVersionNumber ?? " ")
        
        // self.screenTimer = Timer.scheduledTimer(timeInterval: self.screenTime, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        
        if fixValue ?? false {
                   count += 1
                   if count == 1 {
                       self.screenTimer = nil
                       self.screenTimer?.invalidate()
                       self.alertTimer = nil
                       self.alertTimer?.invalidate()
                       backBtn.isUserInteractionEnabled = true
                      // backBtn.setImage(UIImage.init(named: "BackArrow"), for: .normal)
                        backBtn.setImage(UIImage.setImageFromBundle(name: "stap_BackArrow")!/*UIImage.init(named: "BackArrowCircle")*/, for: .normal)
                       sentView.frame = pickerView.bounds
                       pickerView.addSubview(self.sentView)
                     //  buttonStackView.isUserInteractionEnabled = false
                       finalAmountLabel.attributedText = NSMutableAttributedString().normal("Enviaste ").bold("$").bold(amountPagar.shownAmount())
                   }else{
                       printLog("view present")
                   }
                   
               }else{
                   backBtn.isUserInteractionEnabled = true
                   backBtn.setImage(UIImage.setImageFromBundle(name: "stap_BackArrow")!/*UIImage.init(named: "BackArrowCircle")*/, for: .normal)
                  // buttonStackView.isUserInteractionEnabled = false
                  // progressView.removeFromSuperview()
                   progressView.frame = CGRect(x: 3, y: 2, width: UIScreen.main.bounds.size.width - 6, height: 220) //pickerView.bounds
            
            if pickerView.subviews.contains(progressView){
                       self.progressView.removeChildView()
                       self.progressView.removeFromSuperview()
                       pickerView.addSubview(self.progressView)
                       progressView.showActivityIndicatory()
                   }else{
                       pickerView.addSubview(self.progressView)
                       progressView.showActivityIndicatory()
                   }

                  
                      
                   let network = try? Reachability()
                   self.screenTimer?.invalidate()
                   if (network?.isConnectedToNetwork ?? false) {
                       progressFlag = false
                       let skk:String = RandomKey().generateRandomBytes()!
                       let deviceId:String = RandomKey().getDeviceId(length: 10)//RandomKey().randomNumString(length: 10)//"1234567890"//
                       rsaKey = RSAEncryptionService.init(deviceId: deviceId, skk: skk)
                       SignIn.signIn(rsaKey: rsaKey!){ result in
                           switch result {
                           case .success(let data):
                               self.signIn = data
                               self.progressView.removeChildView()
                               self.progressView.removeFromSuperview()
                               if (self.signIn?.body != nil){
                                   self.amountValidation(amount: self.amount, alertLabel: self.fixAmountValiationLabel)
                                   self.restTimer()
                               }else{
                                   if self.signIn?.code ?? " " == "009" {
                                       self.deviceIdLabel.isHidden = true
                                       self.superMovilAlertView.frame = self.pickerView.bounds
                                       self.pickerView.addSubview(self.superMovilAlertView)
                                   }else{
                                       self.alert(self.signIn?.desc ?? " ")
                                   }
                               }
                           case .failure(let error):
                               printLog(error)
                               self.progressView.removeChildView()
                               self.progressView.removeFromSuperview()
                               self.alert(AlertMessage.networkError)
                               break
                           }
                       }
                   }else{
                       progressFlag = false
                       self.progressView.removeChildView()
                       self.progressView.removeFromSuperview()
                       alert("Red no disponible")
                   }
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        printLog("Will Transition to size \(size) from super view size \(self.view.frame.size)")

        if (size.width > self.view.frame.size.width) {
            printLog("Landscape")
        } else {
            printLog("Portrait")
        }



    }
    
    // MARK:- Button Actions
    
    func removeLastView() {
        if pickerView != nil {
            if(pickerView.subviews.contains(sentView)){
                sentView.removeFromSuperview()
            }else if(pickerView.subviews.contains(passwordView)){
                passwordView.removeFromSuperview()
            }else if(pickerView.subviews.contains(amountView)){
                amountView.removeFromSuperview()
            }else if(pickerView.subviews.contains(numericView)){
                if (numericView.subviews.contains(amountView)) {
                    amountView.removeFromSuperview()
                }else{
                    numericView.removeFromSuperview()
                    dynamicAmountPicker.selectRow(0, inComponent: 0, animated: true)
                    amount = arrofValue?[0] ?? "0.0"
                }
            }else{
                removeParentView()
                self.delegate?.setMessageUi(setMessageUi: true)
            }
        }else{
            self.delegate?.setMessageUi(setMessageUi: true)
            
        }
        
    }
    
    func removeParentView() {
        clearMemory()
       // self.delegate?.setKeyBoard(keyboardtype: .alphabetic(uppercased: true))
        // self.dismiss(animated: true, completion: nil)
    }
    
    func clearMemory() {
        buttonView = nil
        arrofValue = nil
        screenTimer = nil
        alertTimer = nil
        alertTimer?.invalidate()
        screenTimer?.invalidate()
        timerAlertView.removeFromSuperview()
        sentView.removeFromSuperview()
        amountView.removeFromSuperview()
        passwordView.removeFromSuperview()
        numericView.removeFromSuperview()
        if pickerView != nil{
            pickerView.removeFromSuperview()
        }
        self.removeFromParent()
    }
    
    @objc func runTimedCode(){
       // self.removeLastView()
        if timerAlertView != nil && pickerView != nil {
            alertTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
            timerAlertView.frame = CGRect.init(x: 0, y: 0, width: pickerView.bounds.size.width, height: 200)
            pickerView.addSubview(timerAlertView)
            
           
        }
    }
    
    
    @objc func dismissAlert(){
        self.removeParentView()
        self.delegate?.setMessageUi(setMessageUi: false)
    }
    
    
    
    func restTimer(){
        self.screenTimer?.invalidate()
        self.screenTimer = Timer.scheduledTimer(timeInterval: self.screenTime, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
    }
    
    
   /* @IBAction func onBackBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        removeLastView()
      //  self.dismiss(animated: true, completion: nil)
    }
    */
    
    @IBAction func onKeyBoardBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        removeParentView()
       // self.restTimer()
    }
    
    @IBAction func onBackBtnClick(_ sender: Any) {
    UIDevice.current.playInputClick()
     //self.delegate?.setMessageUi(setMessageUi: true)
        removeLastView()
        //self.restTimer()
    }
    
    @IBAction func onDollarBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
       // buttonStackView.isUserInteractionEnabled = false
        backBtn.isUserInteractionEnabled = true
        amount = "0.00"
        amountTextfield.text = ""
        numericView.frame = pickerView.bounds
        pickerView.addSubview(self.numericView)
        self.amountValidation(amount: amount, alertLabel: manualAmountValidationLabel)
    }
    
    @IBAction func onAmountFixBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
        passwordTextfield.text = ""
        if (!(Amount.minimumAmount == 0.0 && Amount.maximumAmount == 0.0)){
            if amount.count > 0 {
                amountPagar = amount
                passwordView.frame = pickerView.bounds
                pickerView.addSubview(self.passwordView)
            }
        }
        
    }
    
    @IBAction func onFixAmountSubmitBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
        backBtn.isUserInteractionEnabled = true
        let manualAmount:Double = Double(amount) ?? 0.0
         if (!(Amount.minimumAmount == 0.0 && Amount.maximumAmount == 0.0)){
            if (Amount.minimumAmount <= manualAmount && manualAmount <= Amount.maximumAmount)  {
                       let amountShow:String = String(manualAmount)
                     //  buttonStackView.isUserInteractionEnabled = false
                       amountLabel.attributedText = NSMutableAttributedString().normal("Vas a enviar ").bold("$").bold(amountShow.shownAmount())
                       amountView.frame = pickerView.bounds
                       pickerView.addSubview(self.amountView)
                   }
            
        }
       
    }
    
    @IBAction func manualAmountBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
        let manualAmount:Double = Double(amount) ?? 0.0
        if (Amount.minimumAmount <= manualAmount && manualAmount <= Amount.maximumAmount)  {
            let amountShow:String = String(manualAmount)
          //  buttonStackView.isUserInteractionEnabled = false
            amountLabel.attributedText = NSMutableAttributedString().normal("Vas a enviar ").bold("$").bold(amountShow.shownAmount())
            amountView.frame = numericView.bounds
            numericView.addSubview(self.amountView)
        }
    }
    
    @IBAction func onPasswordSubmitBtnClick(_ sender: Any) {
        var count = 0
        UIDevice.current.playInputClick()
       // self.restTimer()
        self.screenTimer = nil
        self.screenTimer?.invalidate()
        self.alertTimer = nil
        self.alertTimer?.invalidate()
        let skk:String = RandomKey().generateRandomBytes()!
        let deviceId:String = RandomKey().getDeviceId(length: 10)//RandomKey().randomNumString(length: 10)//"1234567890"//
        rsaKey = RSAEncryptionService.init(deviceId: deviceId, skk: skk)
        if ((passwordTextfield.text?.count ?? 0 > 3) && (passwordTextfield.text?.count ?? 0 < 7)) {
            self.passwordView.removeFromSuperview()
            progressView.frame = pickerView.bounds
            pickerView.addSubview(self.progressView)
            progressView.showActivityIndicatory()
            amountPagar = amount
            let network = try? Reachability()
            if (network?.isConnectedToNetwork ?? false) {
                
                SignIn.signIn(rsaKey: self.rsaKey!){ result in
                    switch result {
                    case .success(let data):
                        self.signIn = data
                        if self.signIn?.body != nil {
                            if let authToken = UserDefaults.standard.string(forKey: AuthConstant.authToken){
                                self.getData(authToken: authToken,password: self.passwordValue ,signIn: data){ result in
                                    switch result{
                                    case .success(let data):
                                        genratURLModel = data
                                        if genratURLModel?.body != nil {
                                            UserDefaults.standard.set(true, forKey: "message")
                                            self.progressView.removeChildView()
                                            self.progressView.removeFromSuperview()
                                            self.amountView.removeFromSuperview()
                                            self.numericView.removeFromSuperview()
                                            self.finalAmountLabel.attributedText = NSMutableAttributedString().normal("Enviaste ").bold("$").bold(amountPagar.shownAmount())
                                            self.amountShowingLabel.attributedText = NSMutableAttributedString().normal("Te enviaron:").bold("$").bold(amountPagar.shownAmount())
                                            
                                            
                                            let messageText = genratURLModel?.body?.message ?? " "
                                            let messageArray = messageText.components(separatedBy: ".")
                                            
                                            let aquaMessage = messageArray[3] ?? " "
                                            let aquamessageArray = aquaMessage.components(separatedBy: ":")
                                            
                                            self.messageShowingLabel.text = messageArray[0] + "." + messageArray[1]
                                            
                                            self.messageFinalScreen.frame = self.pickerView.bounds
                                            let mgImage:UIImage = self.imageWithLabel(label: self.messageShowingLabel)
                                            
                                            
                                            self.msgLabelTextfield.text = self.messageShowingLabel.text
                                            self.msgLabelText2field.text = messageArray[2]
                                            self.msgLabelText3Field.text = aquamessageArray[0]
                                            //let text = messageArray[0] + messageArray[1] + "\n" + messageArray[2] + "\n" + aquamessageArray[0]
                                            
                                            //self.textImageView.image = self.textToImage(drawText: text as NSString, inImage: self.textImageView.image!)
                                            
                                          //  self.textImageView.image = mgImage
                                          //  self.textImageView.contentMode = .scaleAspectFit
                                        
                                            //self.messageFinalScreen.frame = self.pickerView.bounds
                                            self.messageFinalScreen.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 10.0, height: 250)
                                            self.mainView.addSubview(self.messageFinalScreen)
                                            let msgViewImage:UIImage = self.uiviewForMsg.snapshot(of: self.uiviewForMsg.bounds, afterScreenUpdates: true)!
                                            
                                            let urlbody = urlBody.init(link: genratURLModel?.body?.link ?? " ", message: genratURLModel?.body?.message ?? " ", linkPassword: genratURLModel?.body?.linkPassword ?? " ")
                                            let model = GenerateURLModelResponse.init(code: genratURLModel?.code ?? " ", desc: genratURLModel?.desc ?? " ", body: urlbody)
                                            
                                            self.messageFinalScreen.removeFromSuperview()
                                            self.delegate?.addURLMessage(model, layoutImg: msgViewImage)
                                            self.sentView.frame = self.pickerView.bounds
                                            self.pickerView.addSubview(self.sentView)
                                           DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                                  self.delegate?.setMessageUi(setMessageUi: true)
                                           }
                                           
                                           
                                            
                                            printLog(data)
                                            break
                                        }else{
                                            self.alert(data.desc)
                                        }
                                        
                                    case .failure(let error):
                                        printLog(error)
                                        self.progressView.removeChildView()
                                        self.alert(AlertMessage.networkError)
                                        break
                                    }
                                }
                            }
                        }else{
                            self.alert(self.signIn?.desc ?? " ")
                        }
                    case .failure(let error):
                        printLog(error)
                        if count <= 0 {
                            count += 1
                            SignIn.signIn(rsaKey: self.rsaKey!){ result in
                                switch result {
                                case .success(let data):
                                    self.signIn = data
                                    if self.signIn?.body != nil {
                                        if let authToken = UserDefaults.standard.string(forKey: AuthConstant.authToken){
                                            self.getData(authToken: authToken,password: self.passwordValue ,signIn: data){ result in
                                                switch result{
                                                case .success(let data):
                                                    genratURLModel = data
                                                    if genratURLModel?.body != nil {
                                                        UserDefaults.standard.set(true, forKey: "message")
                                                        self.progressView.removeChildView()
                                                        self.progressView.removeFromSuperview()
                                                        self.removeFromParent()
                                                        self.finalAmountLabel.attributedText = NSMutableAttributedString().normal("Enviaste ").bold("$").bold(amountPagar.shownAmount())
                                                        self.uiviewForMsg.frame = self.pickerView.bounds
                                                        self.pickerView.addSubview(self.uiviewForMsg)
                                                        self.delegate?.setMessageUi(setMessageUi: true)
                                                        self.delegate?.addURLMessage(genratURLModel!, layoutImg: self.createLayoutImage())
                                                      //  self.delegate?.sendAmount(keyboardAction: .character("Enviar"),genrateURLModel: data, view: self.view)
                                                        printLog(data)
                                                        break
                                                    }else{
                                                        self.alert(data.desc)
                                                    }
                                                    
                                                case .failure(let error):
                                                    printLog(error)
                                                    self.progressView.removeChildView()
                                                    self.alert(AlertMessage.networkError)
                                                    break
                                                }
                                            }
                                        }
                                    }else{
                                        self.alert(self.signIn?.desc ?? " ")
                                    }
                                case .failure(let error):
                                    printLog(error)
                                    self.progressView.removeChildView()
                                    self.alert(AlertMessage.networkError)
                                    break
                                }
                            }
                        }else{
                            self.progressView.removeChildView()
                            self.alert(AlertMessage.networkError)
                            break
                        }
                    }
                }
            }else{
                self.progressView.removeChildView()
                self.alert("Red no disponible")
            }
        }else{
            //password less than 4 digit
        }
    }
    
    func getData(authToken:String,password:String,signIn:SignInKeyboardModelResponse,_ completion: @escaping ((NetworkResult<GenerateURLModelResponse, ErrorResult>) -> Void)){
        
        AccessToken.getacessToken(signIN: signIn){results in
            switch results{
                
            case .success(let data):
                let generatePayU = GenerateURLServiceRequest.init(deviceId: self.rsaKey!.deviceId, amount:amountPagar,softToken:password/*"eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1ODUwMzcyODYsImhhc2giOiJlYzNlNzI2MTFkMjAwMmFhZGFmZmJjODBlNzcwZGZiYiIsInVzZXJuYW1lIjoiMTIzNDU2Nzg5MDEyMzQ1Njc4OTAifQ.e9VX99uP2p4WJLfln9lE4o_B6XjE4RERg-cXY6GY2hvwlYrGRH00hYbe2LTNKOiY-7n5jO9k2ELCU0NoRB3WLQ"*/)
                GeneratePaymentURL.getURL(genrateURLSErvice: generatePayU, skk:self.rsaKey?.skk ?? " ", authoriztion: authToken, authToken: data.access_token){ result in
                    switch result{
                    case .success(let urldata):
                        completion(.success(urldata))
                        break
                    case .failure(let error):
                        // printLog(error)
                        self.progressView.removeChildView()
                        self.progressView.removeFromSuperview()
                        self.alert(AlertMessage.networkError)
                        break
                    }
                }
                
            case .failure(let error):
                // printLog(error)
                self.progressView.removeChildView()
                self.progressView.removeFromSuperview()
                self.alert(AlertMessage.networkError)
                break
            }
        }
    }
    
    
    
    
    func alert(_ message: String) {
        let seconds = 7.0
        let alerter = ToastAlert()
        alerter.alert(message: message, in: self.view, withDuration: seconds)
         NotificationCenter.default.addObserver(self, selector: #selector(CustomMessageViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
           }
           
          
           @objc func methodOfReceivedNotification(notification: Notification) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.delegate?.setMessageUi(setMessageUi: false)
                self.removeParentView()
            }
    }
    
    @IBAction func onNumberBtnKeyClick(_ sender: Any) {
        let button:UIButton = sender as! UIButton
        printLog(button.tag)
        UIDevice.current.playInputClick()
        self.restTimer()
        switch button.tag {
        case 20:
            textEntering(numVal: "0")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 21:
            textEntering(numVal: "1")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 22:
            textEntering(numVal: "2")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 23:
            textEntering(numVal: "3")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 24:
            textEntering(numVal: "4")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 25:
            textEntering(numVal: "5")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 26:
            textEntering(numVal: "6")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 27:
            textEntering(numVal: "7")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 28:
            textEntering(numVal: "8")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 29:
            textEntering(numVal: "9")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        case 200:
            textEntering(numVal: "-")
            amountTextfield.text = "$" + amount.shownAmount()
            break
        default: break
        }
    }
    
    @IBAction func onPasswordNumBtnKeyClick(_ sender: Any) {
        let button:UIButton = sender as! UIButton
        printLog(button.tag)
        UIDevice.current.playInputClick()
        self.restTimer()
        switch button.tag {
        case 30:
            passwordEntering(numVal: "0")
            passwordTextfield.text = password
            break
        case 31:
            passwordEntering(numVal: "1")
            passwordTextfield.text = password
            break
        case 32:
            passwordEntering(numVal: "2")
            passwordTextfield.text = password
            break
        case 33:
            passwordEntering(numVal: "3")
            passwordTextfield.text = password
            break
        case 34:
            passwordEntering(numVal: "4")
            passwordTextfield.text = password
            break
        case 35:
            passwordEntering(numVal: "5")
            passwordTextfield.text = password
            break
        case 36:
            passwordEntering(numVal: "6")
            passwordTextfield.text = password
            break
        case 37:
            passwordEntering(numVal: "7")
            passwordTextfield.text = password
            break
        case 38:
            passwordEntering(numVal: "8")
            passwordTextfield.text = password
            break
        case 39:
            passwordEntering(numVal: "9")
            passwordTextfield.text = password
            break
        case 300:
            passwordEntering(numVal: "-")
            passwordTextfield.text = password
            break
        default: break
            
        }
    }
    
    //MARK:- textfield delegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == amountTextfield {
            printLog("amount:\(String(describing: amountTextfield.text))")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    @IBAction func onDoneButtonClick(_ sender: Any) {
        self.sentView.frame = self.pickerView.bounds
       self.pickerView.addSubview(self.sentView)
       
       let urlbody = urlBody.init(link: genratURLModel?.body?.link ?? " ", message: genratURLModel?.body?.message ?? " ", linkPassword: genratURLModel?.body?.linkPassword ?? " ")
       let model = GenerateURLModelResponse.init(code: genratURLModel?.code ?? " ", desc: genratURLModel?.desc ?? " ", body: urlbody)
       self.delegate?.addURLMessage(model, layoutImg: self.uiviewForMsg.snapshot(of: self.uiviewForMsg.bounds, afterScreenUpdates: true))
        
    }
    
    
    
    
    //MARK:- Alert Button Click
       
       @IBAction func onGoingBtnClick(_ sender: Any) {
           self.restTimer()
           self.alertTimer?.invalidate()
           self.timerAlertView.removeFromSuperview()
           
       }
       
       
       @IBAction func onCancelBtnClick(_ sender: Any) {
           self.screenTimer?.invalidate()
            self.screenTimer = nil
           // self.removeLastView()
            self.removeParentView()
             self.delegate?.setMessageUi(setMessageUi: false)
       }
    
    @IBAction func onButtonClickAbrir(_ sender: Any) {
        //removeParentView()
        removeLastView()
        self.delegate?.setMessageUi(setMessageUi: true)
        let url = NSURL(string:"https://apps.apple.com/mx/app/superm%C3%B3vil/id498944221")
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
    
    @IBAction func onClickSetting(_ sender: Any) {
    /*    if let url = URL(string: UIApplication.openSettingsURLString) {
            let context = NSExtensionContext()
            context.open(url as URL, completionHandler: nil)

                   var responder = self as UIResponder?
                   while (responder != nil){
                       if responder?.responds(to: Selector("openURL:")) == true{
                           responder?.perform(Selector("openURL:"), with: url)
                       }
                       responder = responder!.next
                   }
        }*/
        
        self.superMovilAlertView.frame = self.pickerView.bounds
        self.pickerView.addSubview(self.superMovilAlertView)
    
    }
    
    
    
    
    
}

// MARK:- UIPickerView Delegate

extension CustomMessageViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrofValue?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerViewAmount = (self.arrofValue?[row])!
        amount = pickerViewAmount
        // self.amountValidation(amount: amount, alertLabel: fixAmountValiationLabel)
        return self.arrofValue![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        pickerViewAmount = (self.arrofValue?[row])!
        amount = pickerViewAmount
        self.amountValidation(amount: amount, alertLabel: fixAmountValiationLabel)
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
    }
    
    func textEntering(numVal:String)  {
        let numVal = numVal//action.getNumberString
        let t0 = Double(amount) ?? 0.0
        let t1 = Int(t0*100)
        let t2 = String(t1)
        if(numVal=="C"){
            amount = "0.00"
            self.amountValidation(amount: amount, alertLabel: manualAmountValidationLabel)
        }else if(numVal=="-"){
            if(t2.count==1){
                amount = "0.00"
            }else if(t2.count>1){
                let t3 = String(t2)
                let t4 = t3.dropLast()
                var t5 = Double(t4) ?? 0.0
                t5 = t5/100
                amount = String(t5)
                let amountPagarArr = amount.components(separatedBy: ".")
                let afterDecimal: String! = amountPagarArr.count > 1 ? amountPagarArr[1] : nil
                if(afterDecimal.count==1){
                    amount = amount + "0"
                }
            }
            self.amountValidation(amount: amount, alertLabel: manualAmountValidationLabel)
        }else if(t2.count<6){
            if(amount=="0.00"){
                amount = "0.0"+numVal
            }else{
                var t0 = Double(amount) ?? 0.0
                t0 = t0 * 100
                let t1 = Int(t0)
                let t2 = String(t1)
                if(t2.count==1){
                    amount = "0." + t2 + numVal
                }else if(t2.count>1){
                    let t3 = t2 + numVal
                    var t4 = Double(t3) ?? 0.0
                    t4 = t4/100
                    amount = String(t4)
                    let amountPagarArr = amountPagar.components(separatedBy: ".")
                    let afterDecimal: String  = amountPagarArr.count > 1 ? amountPagarArr[1] : " "
                    if(afterDecimal.count == 1){
                        amount = amount + "0"
                        
                    }
                }
            }
            printLog("amount: \(amount)")
            self.amountValidation(amount: amount, alertLabel: manualAmountValidationLabel)
        }
    }
    
    
    func amountValidation(amount:String,alertLabel:UILabel) -> Void {
        let manualAmount:Double = Double(amount) ?? 0.0
        Amount.minimumAmount = signIn?.body?.infoClient.minAmount ?? 0.0
        Amount.maximumAmount = signIn?.body?.infoClient.amountAvailable ?? 0.0
        if manualAmount == 0.0 {
            alertLabel.isHidden = true
        }else if (Amount.minimumAmount > Amount.maximumAmount) {
            if signIn?.body?.infoClient.isDailyAvailable ?? false {
                alertLabel.text = AlertMessage.amountExceedAlert
            }else{
                alertLabel.text = AlertMessage.amountExceedMonthlyAlert
            }
            alertLabel.isHidden = false
        }else if (Amount.minimumAmount < manualAmount && manualAmount < Amount.maximumAmount)  {
            alertLabel.isHidden = true
        }else if(manualAmount <= Amount.minimumAmount){
            let alertMsg = AlertMessage.minAmountAlert + (String(Amount.minimumAmount)).shownAmount()//String(manualAmount ?? 0.0)
            alertLabel.text = alertMsg
            alertLabel.isHidden = false
        }else if(manualAmount >= Amount.maximumAmount){
            let alertMsg = AlertMessage.maxAmountAlert + (String(Amount.maximumAmount)).shownAmount()//String(manualAmount ?? 0.0)
            alertLabel.text = alertMsg
            alertLabel.isHidden = false
        }
        
    }
    
   func passwordEntering(numVal:String)  {
        
        let numVal = numVal//action.getNumberString
        if(numVal=="C"){
            password.removeAll()
            passwordValue.removeAll()
        }else if(numVal=="-"){
            if(password.count > 0){
                _ = password.removeLast()
                _ = passwordValue.removeLast()
                
            }
        }else if(passwordTextfield.text?.count == 0){
            password = "*"
            passwordValue = numVal
        }else if(password.count < 7){
            password = password + "*"
            passwordValue = passwordValue + numVal
        }
    }
    
    
//password length update
    
    func textToImage(drawText text: NSString, inImage image: UIImage) -> UIImage {
        //draw image first
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        //text attributes
        let font=UIFont(name: "SantanderText-Bold", size: 21)!
        let text_style=NSMutableParagraphStyle()
        text_style.alignment=NSTextAlignment.center
        let text_color=UIColor.black
        let attributes=[NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:text_style, NSAttributedString.Key.foregroundColor:text_color]

        //vertically center (depending on font)
        let text_h=font.lineHeight
        let text_y=(image.size.height-text_h)/2
        let text_rect=CGRect(x: 0, y: text_y, width: image.size.width, height: text_h)
        text.draw(in: text_rect.integral, withAttributes: attributes)
        let result=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}



extension String{
    
    func shownAmount() -> String {
        let largeNumber = Double(self) ?? 0.0
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))!
        return String(formattedNumber)
    }
}


extension CustomMessageViewController{
    func createLayoutImage()->UIImage?{
        let size = CGSize(width:self.uiviewForMsg.bounds.width, height: self.uiviewForMsg.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.uiviewForMsg.drawHierarchy(in: self.uiviewForMsg.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView{

func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage? {
    // snapshot entire view

    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
    drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
    let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    // if no `rect` provided, return image of whole view

    guard let image = wholeImage, let rect = rect else { return wholeImage }

    // otherwise, grab specified `rect` of image

    guard let cgImage = image.cgImage?.cropping(to: rect * image.scale) else { return nil }
    return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
}

    
    
    
    @available(iOS 10.0, *)
       public func renderToImage(afterScreenUpdates: Bool = false) -> UIImage {
           let rendererFormat = UIGraphicsImageRendererFormat.default()
           rendererFormat.opaque = isOpaque
           let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

           let snapshotImage = renderer.image { _ in
               drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
           }
           return snapshotImage
       }
    
    
}


extension CGRect {
    static func * (lhs: CGRect, rhs: CGFloat) -> CGRect {
        return CGRect(x: lhs.minX * rhs, y: lhs.minY * rhs, width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
