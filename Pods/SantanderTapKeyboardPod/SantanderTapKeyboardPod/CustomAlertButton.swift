//
//  CustomAlertButton.swift
//  Teclado
//
//  Created by Darshan Bagmar on 09/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//
import Foundation
import UIKit

class CustomAlertButton: KeyboardButtonView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var flag:Bool?
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var trailingImageView: UIImageView!
    
    @IBOutlet weak var leadingImageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    public func setup(with action: KeyboardAction, in viewController: KeyboardInputViewController, distribution: UIStackView.Distribution = .fillEqually) {
        super.setup(with: action, in: viewController)
        backgroundColor = .clearTappable
        DispatchQueue.main.async { self.leadingImageView?.image = UIImage.setImageFromBundle(name: "stap_crossArrow")!}//UIImage(named: "crossArrow") }
        //textLabel?.font = action.buttonFont
        textLabel?.text = action.buttonText
        
        buttonView?.tintColor = action.tintColor(in: viewController)
        width = action.buttonWidth(for: distribution)
        buttonView?.backgroundColor = action.buttonColor(for: viewController)
        
        if (action == .character("www.santander.com.mx")) {
            trailingImageView.isHidden = true
            //textLabel?.textColor = .red
           // buttonView?.backgroundColor = .red
            buttonView?.clipsToBounds = true
            buttonView?.layer.cornerRadius = 10
            buttonView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else if(action == .character("Contáctanos")){
            trailingImageView.isHidden = true
            //textLabel?.textColor = Asset.Colors.darkButton.color
            buttonView?.clipsToBounds = true
            buttonView?.layer.cornerRadius = 10
            buttonView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }else{
            //textLabel?.textColor = Asset.Colors.darkButton.color
            trailingImageView.isHidden = true
            buttonView?.backgroundColor = action.buttonColor(for: viewController)
        }
        
    }

}



private extension KeyboardAction {
    
    func buttonColor(for viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        var asset = useDarkButton
            ? (dark ? Asset.Colors.lightSystemButton : Asset.Colors.lightSystemButton)
            : (dark ? Asset.Colors.darkButton : Asset.Colors.lightButton)
        if(isAppButton){
            asset = Asset.Colors.redButton
        }
        return asset.color
    }
    
    var buttonFont: UIFont {
        return .preferredFont(forTextStyle: buttonFontStyle)
    }
    
    var buttonFontStyle: UIFont.TextStyle {
        switch self {
        case .character: return .title2
        case .shift, .shiftDown, .backspace: return .title1
        case .switchToKeyboard(.emojis): return .title1
        default: return .body
        }
    }
    
    var buttonImage: UIImage? {
        switch self {
        case .image(_, let imageName, _): return UIImage.setImageFromBundle(name: imageName)!//UIImage(named: imageName)
        case .switchKeyboard: return Asset.Images.Buttons.switchKeyboard.image
        default: return nil
        }
    }
    
    var buttonText: String? {
        switch self {
        case .backspace: return "⌫"
        case .character(let text): return text
        case .newLine: return "intro"
        case .shiftDown: return "⇪"
        case .shift: return "⇧"
        case .space: return "espacio"
        case .switchToKeyboard(let type): return buttonText(for: type)
        default: return nil
        }
    }
    
    func buttonText(for keyboardType: KeyboardType) -> String {
        switch keyboardType {
        case .alphabetic: return "ABC"
        case .emojis: return "🙂"
        case .images: return "Pay"
        case .numeric: return "123"
        case .symbolic: return "#+="
        default: return "???"
        }
    }
    
    var buttonWidth: CGFloat {
        switch self {
        case .none: return 10
        case .shift, .shiftDown, .backspace: return 70
        case .space: return 100
        default: return 50
        }
    }
    
    func buttonWidth(for distribution: UIStackView.Distribution) -> CGFloat {
        let adjust = distribution == .fillProportionally
        return adjust ? buttonWidth * 100 : buttonWidth
    }
    
    func tintColor(in viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        let asset = useDarkButton
            ? (dark ? Asset.Colors.darkSystemButtonText : Asset.Colors.lightSystemButtonText)
            : (dark ? Asset.Colors.darkButtonText : Asset.Colors.lightButtonText)
        return asset.color
    }
    
    func useDarkAppearance(in viewController: KeyboardInputViewController) -> Bool {
        let appearance = viewController.textDocumentProxy.keyboardAppearance ?? .default
        return appearance == .dark
    }
    
    var useDarkButton: Bool {
        switch self {
        case .character, .image, .shiftDown, .space: return false
        default: return true
        }
    }
    
    var isAppButton: Bool {
        switch self {
        case .image: if(self.getImageDescription == "app"){ return true } else { return false }
        default: return false
        }
    }
}
