//
//  KeyboardCustomUIViewController.swift
//  Teclado
//
//  Created by Darshan Bagmar on 31/03/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

protocol CustomKeyboardDelegate: class {
    func setKeyBoard(keyboardtype:KeyboardType)
    func sendAmount(keyboardAction:KeyboardAction,genrateURLModel:GenerateURLModelResponse,view:UIView)
}

class KeyboardCustomUIViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageView: UIView!
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
    
    
    @IBOutlet var widgetView: UIView!
    @IBOutlet var widgetStackView: UIStackView!
    @IBOutlet var widgetButton: UIButton!
    
    @IBOutlet var timerAlertView: UIInputView!
    @IBOutlet var deviceIdLabel: UILabel!
    
    var screenTimer: Timer?
    var alertTimer: Timer?
    let screenTime = 50.0
    
    var buttonView:UIView?
    var widgetButtonView:UIView?
    var fixValue:Bool?
    weak var delegate:CustomKeyboardDelegate?
    var timerFlag:Bool? = true
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
        printLog("KeyboardCustomUIViewController is deallocated")
       }
       
    
  
    // MARK:- ViewController Lifecycle
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAmountPicker.dataSource = self
        dynamicAmountPicker.delegate = self
        amountTextfield.delegate = self
        buttonStackView.removeAllArrangedSubviews()
        buttonStackView.addArrangedSubview(buttonView!)
        widgetStackView.removeAllArrangedSubviews()
        widgetStackView.addArrangedSubview(widgetButtonView!)
        pickerView.show()
        dynamicAmountPicker.selectRow(0, inComponent: 0, animated: true)
        amount = arrofValue?[0] ?? "0.0"
        finalAmountLabel.attributedText = NSMutableAttributedString().normal("Enviaste ", fontSizes: 30).bold("$", fontSizes: 30).bold(amountPagar, fontSizes: 30)
        versionLabel.text = "v" + (Bundle.main.releaseVersionNumber ?? " ") + "." + (Bundle.main.buildVersionNumber ?? " ")
        self.deviceIdLabel.text = RandomKey().getDeviceId(length: 10)
        self.deviceIdLabel.isHidden = true
        self.passwordTextfield.isUserInteractionEnabled = false
         self.amountTextfield.isUserInteractionEnabled = false
        self.screenTimer = Timer.scheduledTimer(timeInterval: self.screenTime, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
    
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        if fixValue ?? false {
            count += 1
            if count == 1 {
                backBtn.isUserInteractionEnabled = false
                backBtn.setImage(nil/*UIImage.init(named: "BackArrow")*/, for: .normal)
               // backBtn.isHidden = true
                sentView.frame = pickerView.bounds
                pickerView.addSubview(self.sentView)
                buttonStackView.isUserInteractionEnabled = true
                finalAmountLabel.attributedText = NSMutableAttributedString().normal("Enviaste ").bold("$").bold(amountPagar.shownAmount())
                UserDefaults.standard.set(true, forKey:"widget")
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        self.removeParentSelector()
                }
                
            }else{
                printLog("view present")
            }
            
        }else{
           // backBtn.isHidden = false
            UserDefaults.standard.set(false, forKey:"widget")
            backBtn.isUserInteractionEnabled = true
            backBtn.setImage(UIImage.setImageFromBundle(name: "stap_BackArrowCircle")!/*UIImage.init(named: "BackArrowCircle")*/, for: .normal)
            buttonStackView.isUserInteractionEnabled = false
            progressView.frame = pickerView.bounds
            pickerView.addSubview(self.progressView)
            progressView.showActivityIndicatory()
            let network = try? Reachability()
            if (network?.isConnectedToNetwork ?? false) {
                let skk:String = RandomKey().generateRandomBytes()!
                let deviceId:String =  RandomKey().getDeviceId(length: 10)//RandomKey().randomNumString(length: 10)//"1234567890"//
                rsaKey = RSAEncryptionService.init(deviceId: deviceId, skk: skk)
                self.screenTimer?.invalidate()
                SignIn.signIn(rsaKey: rsaKey!){ result in
                    switch result {
                    case .success(let data):
                        self.signIn = data
                        self.progressView.removeChildView()
                        self.progressView.removeFromSuperview()
                        if (self.signIn?.body != nil){
                            if self.amount.count > 0 && self.fixAmountValiationLabel != nil{
                                 self.amountValidation(amount: self.amount, alertLabel: self.fixAmountValiationLabel)
                                 self.restTimer()
                            }
                        }else{
                           self.alert(self.signIn?.desc ?? " ")
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
                self.progressView.removeChildView()
                self.progressView.removeFromSuperview()
                alert("Red no disponible")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.clearMemory()
       // self.cancelTaskWithUrl(URL.init(string: MAIN_URL)!)
       // return true
    }
    
    
    func cancelTaskWithUrl(_ url: URL) {
      URLSession.shared.getAllTasks { tasks in
        tasks
          .filter { $0.state == .running }
          .filter { $0.originalRequest?.url == url }.first?
          .cancel()
      }
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
            if(pickerView.subviews.contains(widgetView)){
                       widgetView.removeFromSuperview()
                       if pickerView.subviews.contains(sentView){
                           backBtn.isUserInteractionEnabled = false
                           backBtn.setImage(nil/*UIImage.init(named: "BackArrow")*/, for: .normal)
                           UserDefaults.standard.set(true, forKey:"widget")
                           DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                               //if self.timerFlag == true {
                                    self.removeParentSelector()
                               //}
                           }
                       }
                   }else if(pickerView.subviews.contains(sentView)){
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
                           self.amountValidation(amount: amount, alertLabel: fixAmountValiationLabel)
                       }
                   }else{
                       removeParentView()
                   }
        }else{
            printLog("picker view nil")
        }
        
       
    }
    
    func removeParentView() {
        clearMemory()
        self.delegate?.setKeyBoard(keyboardtype: .alphabetic(uppercased: true))
        self.cancelTaskWithUrl(URL.init(string: MAIN_URL)!)
        // self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func removeParentSelector() {
        // Something cool
        
        if UserDefaults.standard.bool(forKey: "widget"){
            UserDefaults.standard.set(false, forKey:"widget")
            self.removeParentView()
        }else{
            printLog("widget launch")
        }
        
    }
    
    func clearMemory() {
        buttonView = nil
        arrofValue = nil
        screenTimer = nil
        screenTimer?.invalidate()
        alertTimer = nil
        alertTimer?.invalidate()
        timerAlertView.removeFromSuperview()
        sentView.removeFromSuperview()
        amountView.removeFromSuperview()
        passwordView.removeFromSuperview()
        numericView.removeFromSuperview()
        if pickerView != nil {
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
        if timerAlertView.window != nil {
            self.removeParentView()
        }
        
    }
    
    
    
    func restTimer(){
        self.screenTimer?.invalidate()
        self.screenTimer = Timer.scheduledTimer(timeInterval: self.screenTime, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
    }
    
    @IBAction func onBackBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        removeLastView()
        self.restTimer()
      //  self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onKeyBoardBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
        removeParentView()
    }
    
    @IBAction func onDollarBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
        buttonStackView.isUserInteractionEnabled = false
        backBtn.isUserInteractionEnabled = true
        amount = "0.00"
        amountTextfield.text = ""
        numericView.frame = pickerView.bounds
        pickerView.addSubview(self.numericView)
        self.amountValidation(amount: amount, alertLabel: manualAmountValidationLabel)
    }
    
    
    @IBAction func onWidgetButtonClick(_ sender: Any) {
    UIDevice.current.playInputClick()
        self.screenTimer?.invalidate()
        self.screenTimer = nil
        self.alertTimer?.invalidate()
        self.alertTimer = nil
    backBtn.isUserInteractionEnabled = true
    UserDefaults.standard.set(false, forKey:"widget")
    widgetView.frame = pickerView.bounds
    pickerView.addSubview(self.widgetView)
    }
    
    @IBAction func onAmountFixBtnClick(_ sender: Any) {
        UIDevice.current.playInputClick()
        self.restTimer()
        passwordTextfield.text = ""
        if (!(Amount.minimumAmount == 0.0 && Amount.maximumAmount == 0.0)) {
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
        if (!(Amount.minimumAmount == 0.0 && Amount.maximumAmount == 0.0)) {
            if (Amount.minimumAmount <= manualAmount && manualAmount <= Amount.maximumAmount)  {
                       let amountShow:String = String(manualAmount)
                       buttonStackView.isUserInteractionEnabled = false
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
            buttonStackView.isUserInteractionEnabled = false
            amountLabel.attributedText = NSMutableAttributedString().normal("Vas a enviar ").bold("$").bold(amountShow.shownAmount())
            amountView.frame = numericView.bounds
            numericView.addSubview(self.amountView)
        }
    }
    
    @IBAction func onPasswordSubmitBtnClick(_ sender: Any) {
        var count = 0
        UIDevice.current.playInputClick()
        self.restTimer()
        let skk:String = RandomKey().generateRandomBytes()!
        let deviceId:String =  RandomKey().getDeviceId(length: 10)//RandomKey().randomNumString(length: 10)//"1234567890"//
        rsaKey = RSAEncryptionService.init(deviceId: deviceId, skk: skk)
        if ((passwordTextfield.text?.count ?? 0 > 3) && (passwordTextfield.text?.count ?? 0 < 7)) {
            self.passwordView.removeFromSuperview()
            progressView.frame = pickerView.bounds
            pickerView.addSubview(self.progressView)
            progressView.showActivityIndicatory()
            amountPagar = amount
            let network = try? Reachability()
            if (network?.isConnectedToNetwork ?? false) {
                self.screenTimer?.invalidate()
                SignIn.signIn(rsaKey: self.rsaKey!){ result in
                    switch result {
                    case .success(let data):
                        self.signIn = data
                        if self.signIn?.body != nil {
                            if let authToken = UserDefaults.standard.string(forKey: AuthConstant.authToken){
                                self.getData(authToken: authToken, password: self.passwordValue, signIn: data){ result in
                                    switch result{
                                    case .success(let data):
                                        genratURLModel = data
                                        if genratURLModel?.body != nil {
                                            UserDefaults.standard.set(true, forKey: "message")
                                            self.progressView.removeChildView()
                                            self.progressView.removeFromSuperview()
                                            self.removeFromParent()
                                            self.delegate?.sendAmount(keyboardAction: .character("Enviar"),genrateURLModel: data, view: self.view)
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
                                                        self.delegate?.sendAmount(keyboardAction: .character("Enviar"),genrateURLModel: data, view: self.view)
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
            printLog("wrong password")
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
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardCustomUIViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
   
    @objc func methodOfReceivedNotification(notification: Notification) {
     DispatchQueue.main.asyncAfter(deadline: .now()) {
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
    }
    
}

// MARK:- UIPickerView Delegate

extension KeyboardCustomUIViewController:UIPickerViewDelegate,UIPickerViewDataSource{
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
        self.restTimer()
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
    }
    
    func textEntering(numVal:String)  {
        let numVal = numVal//action.getNumberString
        let t0 = Double(amount) ?? 0.0
        let t1 = Int(round(t0*100))
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
                t0 = round(t0 * 100)
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
        }else if(password.count < 8){
            password = password + "*"
            passwordValue = passwordValue + numVal
        }
    }
}

class button:DemoButton{
    static var switchAction: KeyboardAction {
        .switchToKeyboard(.alphabetic(uppercased: false))
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
