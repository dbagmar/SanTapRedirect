//
//  KeyboardParentViewController+Setup.swift
//

//import KeyboardKit
import UIKit

extension KeyboardParentViewController {
    
    func setupKeyboard() {
        setupKeyboard(for: self.view.bounds.size)
    }
    
    func setupKeyboard(keyboardtype:KeyboardType) {
        setupKeyboard(for: view.bounds.size)
    }
    
    func setupKeyboard(for size: CGSize) {
        DispatchQueue.main.async {
            self.setupKeyboardAsync(for: size)
        }
    }
    
    func setupKeyboard(for size: CGSize,KeyboardTypes:KeyboardType) {
        DispatchQueue.main.async {
            self.setupKeyboardReisedAsync(keyboardTypes: KeyboardTypes, for: size)
        }
    }
    
    func setupKeyboardAsync(for size: CGSize) {
        keyboardStackView.removeFromSuperview()
        super.viewDidLoad()
        switch keyboardType {
        case .alphabetic(let uppercased): setupAlphabeticKeyboard(uppercased: uppercased)
        case .emojis: setupEmojiKeyboard(for: size)
        case .images: setupVCm(paymentDone: false)
        //case .dyanamicValue: setupVCm()
        case .fixValue: setupTransactionHistoryView()
        case .numeric: setupNumericKeyboard()
        case .symbolic: setupSymbolicKeyboard()
        case .dyanamicValue: setAlert()
        default: setupAlphabeticKeyboard()
        }
    }
    
    // MARK:- call back method
    func setupKeyboardReisedAsync(keyboardTypes:KeyboardType,for size:CGSize) {
        keyboardStackView.removeAllArrangedSubviews()
        keyboardStackView.removeChildView()
        switch keyboardTypes {
        case .alphabetic(let uppercased): setupAlphabeticKeyboard(uppercased: uppercased)
        case .emojis: setupEmojiKeyboard(for: size)
        //case .images: setupPaymentKeyboard()
        case .images: setupVCm(paymentDone: false)
        case .fixValue: setupTransactionHistoryView()
        case .numeric: setupNumericKeyboard()
        case .symbolic: setupSymbolicKeyboard()
        case .dyanamicValue: setAlert()
        default: setupAlphabeticKeyboard()
        }
    }
        
    func setupAlphabeticKeyboard(uppercased: Bool = false) {
        keyboardStackView.removeAllArrangedSubviews()
        paymentKeyboardOpen=false
        let keyboard = AlphabeticKeyboard(uppercased: uppercased, in: self)
        let rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        let config = KeyboardButtonRowCollectionView.Configuration(rowHeight: 50, rowsPerPage: 1, buttonsPerRow: 4)
        let view = KeyboardButtonRowCollectionView(actions: keyboard.actio, configuration: config) { [unowned self] in return self.buttonCollection(for: $0) }
        keyboardStackView.addArrangedSubview(view)
        keyboardStackView.addArrangedSubviews(rows)
    }
    
    func setupEmojiKeyboard(for size: CGSize) {
        let keyboard = EmojiKeyboard(in: self)
        let isLandscape = size.width > 400
        let rowsPerPage = isLandscape ? 4 : 5
        let buttonsPerRow = isLandscape ? 10 : 8
        let config = KeyboardButtonRowCollectionView.Configuration(rowHeight: 40, rowsPerPage: rowsPerPage, buttonsPerRow: buttonsPerRow)
        let view = KeyboardButtonRowCollectionView(actions: keyboard.actions, configuration: config) { [unowned self] in return self.button(for: $0) }
        let bottom = buttonRow(for: keyboard.bottomActions, distribution: .fillProportionally)
        keyboardStackView.addArrangedSubview(view)
        keyboardStackView.addArrangedSubview(bottom)
    }
    
    func setupImageKeyboard(for size: CGSize) {
        let keyboard = ImageKeyboard(in: self)
        let config = KeyboardButtonRowCollectionView.Configuration(rowHeight: 150, rowsPerPage: 1, buttonsPerRow: 1)
        let view = KeyboardButtonRowCollectionView(actions: keyboard.actions, configuration: config) { [unowned self] in return self.button(for: $0) }
        
        let bottom = buttonRow(for: keyboard.bottomActions, distribution: .fillProportionally)
        keyboardStackView.addArrangedSubview(view)
        keyboardStackView.addArrangedSubview(bottom)
    }
    
    func setupNumericKeyboard() {
        keyboardStackView.removeAllArrangedSubviews()
        let keyboard = NumericKeyboard(in: self)
        let rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        
        let alphaKeyBoard = AlphabeticKeyboard(uppercased: true, in: self)
        let config = KeyboardButtonRowCollectionView.Configuration(rowHeight: 50, rowsPerPage: 1, buttonsPerRow: 4)
        let view = KeyboardButtonRowCollectionView(actions: alphaKeyBoard.actio, configuration: config) { [unowned self] in return self.buttonCollection(for: $0) }
        keyboardStackView.addArrangedSubview(view)
        keyboardStackView.addArrangedSubviews(rows)
    }
    
    func setupPaymentKeyboard() {
        amountPagar = "0.00"
        paymentKeyboardOpen=true
        let keyboard = PaymentNumericKeyboard(in: self)
        let rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        keyboardStackView.addArrangedSubviews(rows)
    }
    
    func setupSymbolicKeyboard() {
        keyboardStackView.removeAllArrangedSubviews()
        let keyboard = SymbolicKeyboard(in: self)
        let rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        let alphaKeyBoard = AlphabeticKeyboard(uppercased: true, in: self)
        let config = KeyboardButtonRowCollectionView.Configuration(rowHeight: 50, rowsPerPage: 1, buttonsPerRow: 4)
        let view = KeyboardButtonRowCollectionView(actions: alphaKeyBoard.actio, configuration: config) { [unowned self] in return self.buttonCollection(for: $0) }
        keyboardStackView.addArrangedSubview(view)
        keyboardStackView.addArrangedSubviews(rows)
    }
    
    // MARK:- custom keyboard
    
    func setAlert(){
        keyboardStackView.removeAllArrangedSubviews()
        let keyboard = AlphabeticKeyboard(uppercased: true, in: self)
        let configs = KeyboardButtonRowCollectionView.Configuration(rowHeight: 36, rowsPerPage: 6, buttonsPerRow: 1)
        let collectionView = KeyboardButtonRowCollectionView(actions: keyboard.alertAction, configuration: configs) { [unowned self] in return self.buttonActionSheet(for: $0) }
       // let rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        keyboardStackView.addArrangedSubview(getCustomTopheaderView())
        keyboardStackView.addArrangedSubview(collectionView)
       // keyboardStackView.addArrangedSubviews(rows)
    }

    func setupVCm(paymentDone:Bool) ->  Void {
        
        if (isOpenAccessGranted())
        {
           printLog("ACCESS : ON")
            self.loadViewIfNeeded()
            keyboardStackView.removeAllArrangedSubviews()
            let vc:KeyboardCustomUIViewController = KeyboardCustomUIViewController(nibName: nil, bundle: Bundle(for: KeyboardCustomUIViewController.self))
            let keyboard = AlphabeticKeyboard(uppercased: true, in: self)
            let configs = KeyboardButtonRowCollectionView.Configuration(rowHeight: 33, rowsPerPage: 6, buttonsPerRow: 1)
            let collectionView = KeyboardButtonRowCollectionView(actions: keyboard.alertAction, configuration: configs) { [unowned self] in return self.buttonActionSheet(for: $0) }
              vc.delegate = self
              vc.fixValue = paymentDone
              vc.widgetButtonView = collectionView
              vc.buttonView = getCustomPaymentheaderView()
              keyboardStackView.addArrangedSubview(vc.view)
              self.addChild(vc)
        }
        else{
           printLog("ACCESS : OFF")
            self.loadViewIfNeeded()
            keyboardStackView.removeAllArrangedSubviews()
            let vc:AcessCheckAlertViewController = AcessCheckAlertViewController(nibName: nil, bundle: Bundle(for: AcessCheckAlertViewController.self))
               keyboardStackView.addArrangedSubview(vc.view)
               self.addChild(vc)
        }
        
        
        
       
    }
    
    func setupTransactionHistoryView() {
        
        if (isOpenAccessGranted())
        {
           printLog("ACCESS : ON")
            self.loadViewIfNeeded()
             keyboardStackView.removeAllArrangedSubviews()
             
            // let vc:TransactionHistoryViewController = TransactionHistoryViewController(nibName: "TransactionHistoryViewController", bundle: nil)
             let vc:TransactionHistoryViewController = TransactionHistoryViewController(nibName: nil, bundle: Bundle(for: TransactionHistoryViewController.self))
             
             vc.delegate = self
             vc.buttonView = getCustomTopheaderView()
             keyboardStackView.addArrangedSubview(vc.view)
             self.addChild(vc)
        }else{
            
            self.loadViewIfNeeded()
            keyboardStackView.removeAllArrangedSubviews()
            
            let vc:AcessCheckAlertViewController = AcessCheckAlertViewController(nibName: nil, bundle: Bundle(for: AcessCheckAlertViewController.self))
            
            keyboardStackView.addArrangedSubview(vc.view)
            self.addChild(vc)
            
            printLog("ACCESS : OFF")
        }
        
    }
    
    func getCustomTopheaderView() -> UIView{
        let keyboard = CustomKeyboard(uppercased: true, in: self)
        let topHeaderConfig = KeyboardButtonRowCollectionView.Configuration(rowHeight: 50, rowsPerPage: 1, buttonsPerRow: 4)
        let topHeaderView = KeyboardButtonRowCollectionView(actions: keyboard.historyaction, configuration: topHeaderConfig) { [unowned self] in return self.buttonCollection(for: $0) }
        return topHeaderView
    }
    
    func getCustomPaymentheaderView() -> UIView{
        let keyboard = CustomKeyboard(uppercased: true, in: self)
        let topHeaderConfig = KeyboardButtonRowCollectionView.Configuration(rowHeight: 50, rowsPerPage: 1, buttonsPerRow: 4)
        let topHeaderView = KeyboardButtonRowCollectionView(actions: keyboard.action, configuration: topHeaderConfig) { [unowned self] in return self.buttonCollection(for: $0) }
        return topHeaderView
    }
}
