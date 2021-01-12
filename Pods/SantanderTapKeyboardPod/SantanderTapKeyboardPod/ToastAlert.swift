//
//  ToastAlert.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2018-02-01.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This alerter presents keyboard alert messages at the center
 of the keyboard.
 
 To customize the appearance, you can modify the `appearance`
 property. You can also override the `style` functions.
 
 TODO: This should be refactored to use the appearance proxy
 styling approach, e.g. combined with theme classes.
*/
open class ToastAlert: KeyboardAlert {
    
    
    // MARK: - Initialization
    
    public init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
    }
    
    
    // MARK: - Public Properties
    
    public let appearance: Appearance
    
    
    // MARK: - Types
    
    public class Label: UILabel {}
    
    public class View: UIView {}
    
    public class Button:UIButton {}
    
    public struct Appearance {
        public init() {}
        public var backgroundColor: UIColor = .white
        public var cornerRadius: CGFloat = 10
      //  public var font: UIFont = UIFont(name: "SantanderText-Regular", size: 17.0)!
        public var horizontalPadding: CGFloat = 0
        public var textColor: UIColor = .yellow
        public var verticalOffset: CGFloat = 0
        public var verticalPadding: CGFloat = 0
    }
    
    
    // MARK: - Public functions
    
    open func alert(message: String, in view: UIView, withDuration duration: Double) {
        let label = createLabel(withText: message)
        let button = createButton()
        let container = createContainerView(for: label, button: button, in: view)
       // unpresent(container, withDuration: duration)
    }
    
    open func style(_ view: View) {}
    
    open func style(_ label: Label) {}
    
    open func style(_ button: Button) {}
    
    
    open func unpresent(_ view: View, withDuration duration: Double) {
     DispatchQueue.main.asyncAfter(deadline: .now()) {
                    view.removeFromSuperview()
            }
    }
    
}


// MARK: - Private Functions

private extension ToastAlert {

    func createContainerView(for label: Label,button: Button ,in view: UIView) -> View {
        let container = View(frame: CGRect(x: 5, y: 2, width: UIScreen.main.bounds.size.width - 10, height: 280))
        view.backgroundColor = .clear
        view.addSubview(container)
        view.layer.cornerRadius = 10
        container.layer.cornerRadius = 10
        container.backgroundColor = appearance.backgroundColor
        //container.layer.cornerRadius = appearance.cornerRadius
        //container.center = view.center
       // container.frame.origin.y += appearance.verticalOffset
        let alertLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 40, height: 90))
        alertLabel.center = CGPoint(x: view.frame.size.width/2, y:130)
        alertLabel.textAlignment = .center
        alertLabel.text = label.text
        alertLabel.font = UIFont(name: "SantanderText-Regular", size: 14)
        alertLabel.textColor = .darkGray
        alertLabel.numberOfLines = 0
        container.addSubview(alertLabel)
       
        let buttons:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 35))
       buttons.center = CGPoint(x: view.frame.size.width/2, y:220)
        buttons.backgroundColor = .red
        buttons.layer.cornerRadius = 5
        buttons.titleLabel?.font = UIFont(name: "SantanderText-Bold", size: 14)
        buttons.setTitle("De Acuerdo", for: .normal)
       buttons.addTapAction {
            dismissalert = true
            self.unpresent(container, withDuration: 1)
            printLog("button taped")
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        }
        
        //buttons.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        container.addSubview(buttons)
        container.applyShadow(.standardButtonShadow)
        placeContainerView(container, in: view)
        style(container)
        return container
    }
    
   @objc func buttonClicked() {
               printLog("Button Clicked")
    }
    
    
    func createButton() -> Button {
        let button = Button()
        button.center = CGPoint(x: 100, y:210)
        button.backgroundColor = .red
        button.setTitle("De Acuerdo", for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        return button
    }
    
    func createLabel(withText text: String) -> Label {
        let label = Label()
        label.text = text
        label.numberOfLines = 0
       // label.font = appearance.font
        label.textColor = appearance.textColor
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.sizeToFit()
        style(label)
        label.autoresizingMask = .centerInParent
        return label
    }
    
    
    
    func placeContainerView(_ container: UIView, in view: UIView) {
        container.autoresizingMask = .centerInParent
        let dx = -appearance.horizontalPadding
        let dy = -appearance.verticalPadding
        container.frame = container.frame.insetBy(dx: dx, dy: dy)
    }
}

