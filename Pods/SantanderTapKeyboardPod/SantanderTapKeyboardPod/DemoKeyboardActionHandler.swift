//
//  DemoKeyboardActionHandler.swift
//

import UIKit



/**
 
 This action handler inherits `StandardKeyboardActionHandler`
 and adds demo-specific functionality to it.
 
 */
var paymentURL=""
var paymentKeyboardOpen = false
var dismissalert = false
var amountPagar = "0.00"
var genratURLModel:GenerateURLModelResponse?

class DemoKeyboardActionHandler: StandardKeyboardActionHandler {
    
    // MARK: - Initialization
    
    public init(inputViewController: UIInputViewController) {
        keyboardShiftState = .uppercased
        super.init(
            inputViewController: inputViewController,
            hapticConfiguration: .standard
        )
    }
    
    // MARK: - Properties
    
    private var keyboardShiftState: KeyboardShiftState
    
    private var demoViewController: KeyboardParentViewController? {
        inputViewController as? KeyboardParentViewController
    }
    
    // MARK: - Actions
    
    override func longPressAction(for action: KeyboardAction, view: UIView) -> GestureAction? {
        switch action {
        case .image(_, _, let imageName): return { [weak self] in self?.saveImage(UIImage.setImageFromBundle(name: imageName)!) }
        case .backspace: return super.repeatAction(for: .backspace, view: view)
        case .character: return handleCharacterLongPress(action, for: view)
        default: return super.longPressAction(for: action, view: view)
        }
    }
    
    override func repeatAction(for action: KeyboardAction, view: UIView) -> GestureAction? {
        switch action {
        case .shift,.shiftDown:
            UserDefaults.standard.set(false, forKey: KeyBoardKeys.capsLocked)
            return switchToCapsLockedKeyboard
        case .backspace: return super.repeatAction(for: .backspace, view: view)
        default:
            return nil
        }
    }
    
    override func tapAction(for action: KeyboardAction, view: UIView) -> GestureAction? {
        switch action {
        case .character: return handleCharacter(action, for: view)
        case .image(_, _, let imageName): return imageAction(action, UIImage.setImageFromBundle(name: imageName)!, for: view)
        case .shift: return switchToUppercaseKeyboard
        case .shiftDown: return switchToLowercaseKeyboard
        case .space: return handleSpace(for: view)
        case .switchToKeyboard(let type): return { [weak self] in self?.demoViewController?.keyboardType = type }
        default: return super.tapAction(for: action, view: view)
        }
    }
    
    
    // MARK: - Action Handling
    
    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, view: UIView) {
        super.handle(gesture, on: action, view: view)
        demoViewController?.requestAutocompleteSuggestions()
    }
    
    override func handleRepeat(on action: KeyboardAction, view: UIView) {
        super.handle(.repeatPress, on: action, view: view)
    }
}


// MARK: - Image Functions

@objc extension DemoKeyboardActionHandler {
    
    func handleImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil { alert("Saved!") }
        else { alert("Failed!") }
    }
}


// MARK: - Actions

private extension DemoKeyboardActionHandler {
    
    func alert(_ message: String) {
        guard let input = inputViewController as? KeyboardParentViewController else { return }
        input.alerter.alert(message: message, in: input.view, withDuration: 5)
    }
    
    func copyImage(_ image: UIImage) {
        guard let input = inputViewController as? KeyboardParentViewController else { return }
        guard input.hasFullAccess else { return alert("You must enable full access to copy images.") }
        guard image.copyToPasteboard() else { return alert("The image could not be copied.") }
        alert("Copied to pasteboard!")
    }
    
    // MARK:- set keyboard type
    
    func imageAction(_ action: KeyboardAction, _ image: UIImage, for view: UIView) -> GestureAction {
        var type: KeyboardType = .alphabetic(uppercased: true)
        var baseAction = super.tapAction(for: .image(description: "Keyboard", keyboardImageName: "Keyboard", imageName: "Keyboard"), view: view)
        
        if(action.getImageDescription=="enviarUnselected" || action.getImageDescription == "enviarSelected"){
            type = .images
            return { [weak self] in self?.demoViewController?.keyboardType = type}
        }else if(action.getImageDescription=="app"){
            
            type = .dyanamicValue
            return { [weak self] in self?.demoViewController?.keyboardType = type}
            
        }else if(action.getImageDescription=="appRed"){
            
            type = .dyanamicValue
            return { [weak self] in self?.demoViewController?.keyboardType = type}
            
        }else if(action.getImageDescription=="Keyboard"){
            baseAction = super.tapAction(for: .none, view: view)
            return { baseAction?()}
            
        }else if(action.getImageDescription=="KeyboardWork"){
            
            type = .alphabetic(uppercased: true)
            return { [weak self] in self?.demoViewController?.keyboardType = type}
            
        }else if(action.getImageDescription=="BackArrowCircle"){
            type = .alphabetic(uppercased: true)
            return { [weak self] in self?.demoViewController?.keyboardType = type}
            
        }else if(action.getImageDescription=="servicios"){
            return { baseAction?() }
        }else if(action.getImageDescription=="atm"){
            return { baseAction?() }
            
            
        }else if(action.getImageDescription=="BackArrow"){
            return {[weak self] in self?.demoViewController?.dismissKeyboard() }
            
            
        }else{
            return { baseAction?() }
        }
    }
    
    func handleCharacterLongPress(_ action: KeyboardAction, for view: UIView) -> GestureAction {
        var selctedString = ""
        if let selectedCharacter = UserDefaults.standard.object(forKey: "SelectedCharString") {
            UserDefaults.standard.set(nil, forKey: "SelectedCharString")
            selctedString = selectedCharacter as! String
        }
        let baseAction = super.tapAction(for: .character(selctedString), view: view)
        return { [weak self] in
            baseAction?()
            let isUppercased = self?.keyboardShiftState == .uppercased
            guard isUppercased else { return }
            self?.switchToAlphabeticKeyboard(.lowercased)
        }
    }
    
    func handleCharacter(_ action: KeyboardAction, for view: UIView) -> GestureAction {
        var baseAction = super.tapAction(for: action, view: view)
        let num = action.getNumberString
        if action.isEnviar || action.isHistorial || action.isBankURL ||  action.isSantadarTap ||  action.isTutorialIOS ||  action.isTutorialAndroid ||  action.isContactanos {
            if action.isHistorial{
                return { [weak self] in self?.demoViewController?.keyboardType = .fixValue}
            }else if(action.isBankURL){
                return { [weak self] in self?.demoViewController?.addAlert(urlString: "https://www.santander.com.mx/")}
            }else if(action.isSantadarTap){
                return { [weak self] in self?.demoViewController?.addAlert(urlString: "https://www.santander.com.mx/personas/santander-digital/santandertap.html")}
                
               // return { [weak self] in self?.demoViewController?.addAlert()}
            }else if(action.isTutorialIOS){
                return { [weak self] in self?.demoViewController?.addAlert(urlString: "https://www.youtube.com/watch?v=FOc9cf519Kc")}
            }else if(action.isTutorialAndroid){
                return { [weak self] in self?.demoViewController?.addAlert(urlString: "https://www.youtube.com/watch?v=gGT1ruTQgw8")}
            }else if(action.isContactanos){
                return { [weak self] in self?.demoViewController?.addAlert(urlString: "https://www.santander.com.mx/")}
            }else{
                if(amountPagar=="0.00"){
                    baseAction = super.tapAction(for: action.pressSpecialCharacter(Amount: String(amountPagar), URL: ""), view: view)
                }else if (amountPagar == " "){
                    
                    var message:String = genratURLModel?.body?.message ?? " "
                    message = message.replacingOccurrences(of: "santandertap.santander.com.mx/", with: "demo.idmission.com/cuxapp/SanTap.jsp?linkId=")
                    
                    baseAction = super.tapAction(for: action.pressSpecialCharacter(Amount: String(amountPagar), URL:message), view: view)
                    baseAction?()
                    return { [weak self] in self?.demoViewController?.setupTransactionHistoryView()}
                    
                    
                }else{
                    
                    var message:String = genratURLModel?.body?.message ?? " "
                    message = message.replacingOccurrences(of: "santandertap.santander.com.mx/", with: "demo.idmission.com/cuxapp/SanTap.jsp?linkId=")
                    
                    baseAction = super.tapAction(for: action.pressSpecialCharacter(Amount: String(amountPagar), URL:message), view: view)
                    baseAction?()
                    return { [weak self] in  self?.demoViewController?.setupVCm(paymentDone: true)}
                    
                }
            }
        }else if(paymentKeyboardOpen){
            let numVal = action.getNumberString
            let t0 = Double(amountPagar)!
            let t1 = Int(t0*100)
            let t2 = String(t1)
            if(numVal=="C"){
                amountPagar = "0.00"
            }else if(numVal=="-"){
                if(t2.count==1){
                    amountPagar = "0.00"
                }else if(t2.count>1){
                    let t3 = String(t2)
                    let t4 = t3.dropLast()
                    var t5 = Double(t4)!
                    t5 = t5/100
                    amountPagar = String(t5)
                    let amountPagarArr = amountPagar.components(separatedBy: ".")
                    let afterDecimal: String! = amountPagarArr.count > 1 ? amountPagarArr[1] : nil
                    if(afterDecimal.count==1){
                        amountPagar = amountPagar + "0"
                    }
                }
            }else if(t2.count<9){
                if(amountPagar=="0.00"){
                    amountPagar = "0.0"+numVal
                }else{
                    var t0 = Double(amountPagar)!
                    t0 = t0 * 100
                    let t1 = Int(t0)
                    let t2 = String(t1)
                    if(t2.count==1){
                        amountPagar = "0." + t2 + numVal
                    }else if(t2.count>1){
                        let t3 = t2 + numVal
                        var t4 = Double(t3)!;
                        t4 = t4/100
                        amountPagar = String(t4)
                        let amountPagarArr = amountPagar.components(separatedBy: ".")
                        let afterDecimal: String! = amountPagarArr.count > 1 ? amountPagarArr[1] : nil
                        if(afterDecimal.count==1){
                            amountPagar = amountPagar + "0"
                        }
                    }
                }
            }
            
            demoViewController?.amountToolbarUpdate()
            baseAction = super.tapAction(for: action.returnEmpty(), view: view)
        }
        return { [weak self] in
            baseAction?()
            let isUppercased = self?.keyboardShiftState == .uppercased
            guard isUppercased else { return }
            if "0"..."9" ~= num {
                   printLog("num : ---->\(num) is number")
               } else {
                   self?.switchToAlphabeticKeyboard(.lowercased)
               }
        }
    }
        
    func handleSpace(for view: UIView) -> GestureAction {
        let baseAction = super.tapAction(for: .space, view: view)
        return { [weak self] in
            baseAction?()
            let isNonAlpha = self?.demoViewController?.keyboardType != .alphabetic(uppercased: false)
            guard isNonAlpha else { return }
        }
    }
    
    func saveImage(_ image: UIImage) {
        guard let input = inputViewController as? KeyboardParentViewController else { return }
        guard input.hasFullAccess else { return alert("You must enable full access to save images to photos.") }
        let saveCompletion = #selector(handleImage(_:didFinishSavingWithError:contextInfo:))
        image.saveToPhotos(completionTarget: self, completionSelector: saveCompletion)
    }
    
    func switchToCapsLockedKeyboard() {
        if UserDefaults.standard.bool(forKey: KeyBoardKeys.capsLocked){
            switchToAlphabeticKeyboard( .uppercased)
        }else{
            UserDefaults.standard.set(true, forKey:KeyBoardKeys.capsLocked )
            switchToAlphabeticKeyboard(.capsLocked)
        }
    }
    
    func switchToLowercaseKeyboard() {
        switchToAlphabeticKeyboard(.lowercased)
    }
    
    func switchToUppercaseKeyboard() {
        UserDefaults.standard.set(false, forKey: KeyBoardKeys.capsLocked)
        switchToAlphabeticKeyboard( .uppercased)
    }
    
    func switchToAlphabeticKeyboard(_ state: KeyboardShiftState) {
        keyboardShiftState = state
        demoViewController?.keyboardType = .alphabetic(uppercased: state.isUppercased)
    }
}
