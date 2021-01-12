//
//  KeyboardParentViewController.swift
//  Teclado
//
//  Created by Pranjal Lamba on 18/02/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit
import CoreLocation
/**
 This demo app handles system actions as normal (e.g. change
 keyboard, space, new line etc.), injects strings and emojis
 into the text proxy and handles the rightmost images in the
 emoji keyboard by copying them to the pasteboard on tap and
 saving them to the user's photo album on long press.
 
 IMPORTANT: To use this demo keyboard, you have to enable it
 in system settings ("Settings/General/Keyboards") then give
 it full access (this requires enabling `RequestsOpenAccess`
 in `Info.plist`) if you want to use image buttons. You must
 also add a `NSPhotoLibraryAddUsageDescription` to your host
 app's `Info.plist` if you want to be able to save images to
 the photo album. This is already taken care of in this demo
 app, so you can just copy the setup into your own app.
 
 The keyboard is setup in `viewDidAppear(...)` since this is
 when `needsInputModeSwitchKey` first gets the correct value.
 Before this point, the value is `true` even if it should be
 `false`. If you find a way to solve this bug, you can setup
 the keyboard earlier.
 
 The autocomplete parts of this class is the first iteration
 of autocomplete support in KeyboardKit. The intention is to
 move these parts to `KeyboardInputViewController` and a new
 api for working with autocomplete.
 
 **IMPORTANT** `textWillChange` and `textDidChange` does not
 trigger when a user types and text is sent to the proxy. It
 however works when the text cursor changes its position, so
 I therefore use a (hopefully temporary) hack, by starting a
 timer that triggers each second and moves the cursor. Since
 this is a nasty hack, it may have yet to be discovered side
 effects. If so, please let me know.
 */


open class KeyboardParentViewController: KeyboardInputViewController,CustomKeyboardDelegate,CLLocationManagerDelegate {
            
    // MARK: - Properties
   
    var keyboardType = KeyboardType.alphabetic(uppercased: true) {
        didSet { setupKeyboard() }
    }
    
    // MARK:Autocomplete
    lazy var autocompleteProvider = DemoAutocompleteSuggestionProvider()
    lazy var autocompleteToolbar: AutocompleteToolbar = {
        AutocompleteToolbar(textDocumentProxy: textDocumentProxy)
    }()
    
    // MARK:AmountToolbar
    lazy var amountToolbar: AmountToolbar = {
        AmountToolbar(textDocumentProxy: textDocumentProxy)
    }()
    
    // MARK:Toolbar
    lazy var toolbar: Toolbar = {
        Toolbar(textDocumentProxy: textDocumentProxy)
    }()

    // MARK: - View Controller Lifecycle
    
    let locationManager = CLLocationManager()
    
    override open func viewDidLoad() {
        UserDefaults.standard.set(false, forKey: KeyBoardKeys.capsLocked)
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.loadMyCustomFont(name: "stap_SantanderText-Regular")
        self.loadMyCustomFont(name: "stap_SantanderText-Bold")
        self.saveData()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        keyboardActionHandler = DemoKeyboardActionHandler(inputViewController: self)
    }
    
    
    let alerter = ToastAlert()
    
    func saveData() {
        let defaults = UserDefaults.standard
        defaults.set("https://bypass-app-paas-heroku.herokuapp.com/v2/", forKey: UAT)
        defaults.set("https://devs-dev.herokuapp.com/v2/", forKey: Dev)
        defaults.set("https://backend-pre.herokuapp.com/v2/", forKey: Dev2)
        defaults.set("https://santandertap.santander.com.mx/v2/", forKey: Prod)
        defaults.set("https://tap-pub-web-mxswap-pre.appls.cto1.paas.gsnetcloud.corp/v2/", forKey: Pre)
    }

    private func loadMyCustomFont(name:String){
        let frameworkBundlePath = Bundle(for: DemoButton.self).bundlePath

        if let bundle = Bundle(path: frameworkBundlePath) {
            guard let fontPath = bundle.path(forResource: name, ofType: "ttf") else { return }
            guard let fontData = NSData(contentsOfFile:fontPath) else { return }
            var error: Unmanaged<CFError>?
            guard let provider = CGDataProvider(data: fontData) else { return }
            if let font = CGFont(provider) {
                CTFontManagerRegisterGraphicsFont(font, &error)
                if error != nil {
                    print(error!) //Or logged it
                } else {
                    print("Font Registered Success")
                }
            }
        } else {
            print("Font Registered Failured")
        }

    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         if self.isDeviceJailbroken {
                   super.dismissKeyboard()
               }else{
                  // super.dismissKeyboard()
                   setupKeyboard()
               }
       // setupKeyboard()
    }
    // MARK:- jailbrake
        var isDeviceJailbroken: Bool {

           guard TARGET_IPHONE_SIMULATOR != 1 else { return false }
           
           
           func canOpenUrl(url: URL?) -> Bool {
                  let selector = sel_registerName("canOpenURL:")
                  var responder = self as UIResponder?
                  while let r = responder, !r.responds(to: selector) {
                      responder = r.next
                  }
                  return (responder!.perform(selector, with: url) != nil)
           }

           
            
           // Check 1 : existence of files that are common for jailbroken devices
           if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Applications/IntelliScreen.app")
            || FileManager.default.fileExists(atPath: "/Applications/FakeCarrier.app")
            || FileManager.default.fileExists(atPath: "/Applications/blackra1n.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/private/var/mobile/Library/SBSettings/Themes")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Veency.plist")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist")
            || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.ikey.bbot.plist")
            || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
            || canOpenUrl(url: URL.init(string: "cydia://package/com.example.package"))
          {

               return true
           }

           // Check 2 : Reading and writing in system directories (sandbox violation)
           let stringToWrite = "Jailbreak Test"
           do {
               try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
               // Device is jailbroken
               return true
           } catch {
               return false
           }
       }
       
    // MARK:- dismiss keyboard
    func dismissCustomKeyboard(){
        super.dismissKeyboard()
    }
    // MARK:- CustomKeyboardDelegate Methods
    
    func sendAmount(keyboardAction: KeyboardAction, genrateURLModel: GenerateURLModelResponse, view: UIView) {
        keyboardActionHandler.handleTap(on: keyboardAction, view: view)
    }
    
    func setKeyBoard(keyboardtype:KeyboardType) {
        setupKeyboard(for: view.bounds.size, KeyboardTypes: keyboardtype)
    }

    // MARK: - Keyboard Functionality
    
    override open func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        requestAutocompleteSuggestions()
    }
    
    override open func selectionWillChange(_ textInput: UITextInput?) {
        super.selectionWillChange(textInput)
        autocompleteToolbar.reset()
    }
    
    override open func selectionDidChange(_ textInput: UITextInput?) {
        super.selectionDidChange(textInput)
        autocompleteToolbar.reset()
    }
    
    
    func addAlert(urlString:String) {
       let vc:AlertViewController = AlertViewController(nibName: nil, bundle: Bundle(for: AlertViewController.self))
        vc.urlStr = urlString
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func openUrl(urlString:String) {
        let url = NSURL(string:urlString)
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

    func canOpenUrl(url: URL?) -> Bool {
           let selector = sel_registerName("canOpenURL:")
           var responder = self as UIResponder?
           while let r = responder, !r.responds(to: selector) {
               responder = r.next
           }
           return (responder!.perform(selector, with: url) != nil)
    }
    
    
    func isOpenAccessGranted() -> Bool {

        if #available(iOSApplicationExtension 10.0, *) {
            UIPasteboard.general.string = "SantanderTapKeyboard"

            if UIPasteboard.general.hasStrings {
                // Enable string-related control...
                UIPasteboard.general.string = ""
                return  true
            }
            else
            {
                UIPasteboard.general.string = ""
                return  false
            }
        } else {
            // Fallback on earlier versions
            if UIPasteboard.general.isKind(of: UIPasteboard.self) {
                return true
            }else
            {
                return false
            }

        }

    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        printLog("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = String(locValue.latitude) + "," + String(locValue.longitude)
        device.location = location
    }
}

