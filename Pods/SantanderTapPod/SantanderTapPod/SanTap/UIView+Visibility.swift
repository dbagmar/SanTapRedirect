//
//  UIView+Visibility.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2019-12-10.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit

extension UIView {

    
    typealias TapAction = () -> Void
        
        /**
         Add a tap gesture recognizer to the view.
        */
        func addTapAction(numberOfTapsRequired: Int = 1, action: @escaping TapAction) {
            tapAction = action
            isUserInteractionEnabled = true
            
            let singleTaprecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
            singleTaprecognizer.numberOfTapsRequired = 1
            addGestureRecognizer(singleTaprecognizer)
            
        }

        /**
         Remove all repeating gesture recognizers from the view.
        */
        func removeTapAction() {
            gestureRecognizers?
                .filter { $0 is UITapGestureRecognizer }
                .forEach { removeGestureRecognizer($0) }
        }
    
    
    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isVisible = true
    }
}


private extension UIView {
    
    struct Key {
        static var id = "tapAction"
        static var isSingletap = true
        static var changeKeyboardTypeDelay: TimeInterval = 0.2
    }

    var tapAction: TapAction? {
        get {
            return objc_getAssociatedObject(self, &Key.id) as? TapAction
        }
        set {
            guard let value = newValue else { return }
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            objc_setAssociatedObject(self, &Key.id, value, policy)
        }
    }

    @objc func handleDoubleTapAction(sender: UITapGestureRecognizer) {
        sender.name = "Double-Tap-Gesture"
        printLog(sender.name!)
        tapAction?()
        Key.isSingletap = false
    }
    
    @objc func handleTapAction(sender: UITapGestureRecognizer) {

        var timer: Timer?
        sender.name = "Single-Tap-Gesture"
        printLog(sender.name!)
        Key.isSingletap = true

        superview?.bringSubviewToFront(self)
            
                tapAction?()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { timer in
            printLog("Timer fired!")
            
            timer.invalidate()
            guard let foundView = self.viewWithTag(1002) else {return}
            for view in foundView.subviews {
                view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                view.removeFromSuperview()
            }
            foundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            foundView.removeFromSuperview()
        }
    }
    
    func addKeyboardPopupLayer(characterString: String) {
        
        let xpadding = CGFloat(3.0)
        let ypadding = CGFloat(3.0)

        let viewOrigin_x = CGFloat(0.0) + xpadding
        let viewOrigin_y = -self.frame.size.height
        let viewSize_width = self.frame.size.width - (2*xpadding)
        let viewSize_height = (self.frame.size.height*2) - (2*ypadding)

        let keyView = UIView(frame: CGRect(x: viewOrigin_x, y: viewOrigin_y, width: viewSize_width, height: viewSize_height))
        keyView.backgroundColor = .clear
        keyView.tag = 1002
        self.addSubview(keyView)

        let keyView_x = keyView.bounds.origin.x
        let keyView_y = keyView.bounds.origin.y
        let keyView_width = keyView.bounds.size.width
        let keyView_height = keyView.bounds.size.height

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "PopUpLayer"
        shapeLayer.position = CGPoint(x: 0, y: 0)
        shapeLayer.path = createBezierPath(xOrigin: keyView_x, yOrigin: keyView_y, width: keyView_width, height: keyView_height).cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.borderWidth = 0.05
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shapeLayer.shadowRadius = 5
        shapeLayer.shadowOpacity = 0.5
        keyView.layer.addSublayer(shapeLayer)
                
        let popupLabel_padding = CGFloat(5.0)
        let popupLabel_height = (keyView_height/2) - (2*popupLabel_padding)
        let textLabel = UILabel(frame: CGRect(x: keyView_x, y: popupLabel_padding, width: keyView_width, height: popupLabel_height))
        textLabel.font = textLabel.font.withSize(32)
        textLabel.text = characterString
        textLabel.textColor = .black
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .center
        textLabel.contentMode = .center
        textLabel.layer.cornerRadius = 5
        textLabel.clipsToBounds = true
        keyView.addSubview(textLabel)
    }

    func createBezierPath(xOrigin:CGFloat, yOrigin:CGFloat, width:CGFloat, height:CGFloat) -> UIBezierPath {
        
        let heightCenter = height/2
        let padding : CGFloat = 10

        // create a new path
        let path = UIBezierPath()

        // starting point for the path (bottom left)
        path.move(to: CGPoint(x: xOrigin, y: height-padding))

        // *********************
        // ***** Left side *****
        // *********************

        // segment 1: line
        path.addLine(to: CGPoint(x: xOrigin, y: heightCenter+padding))

        // segment 2: curve
        path.addCurve(to: CGPoint(x: xOrigin-padding, y: heightCenter-padding), // ending point
            controlPoint1: CGPoint(x: xOrigin, y: heightCenter),
            controlPoint2: CGPoint(x: xOrigin-padding, y: heightCenter))

        // segment 3: line
        path.addLine(to: CGPoint(x: xOrigin-padding, y: yOrigin+padding))

        // *********************
        // ****** Top side *****
        // *********************

        // segment 4: arc
        path.addArc(withCenter: CGPoint(x: xOrigin, y: yOrigin+padding), // center point of circle
                    radius: padding, // this will make it meet our path line
                    startAngle: CGFloat(Double.pi), // π radians = 180 degrees = straight left
                    endAngle: CGFloat(3*Double.pi/2), // 3π/2 radians = 270 degrees = straight up
                    clockwise: true) // startAngle to endAngle goes in a clockwise direction

        // segment 5: line
        path.addLine(to: CGPoint(x: width, y: yOrigin))

        // segment 6: arc
        path.addArc(withCenter: CGPoint(x: width, y: yOrigin+padding), // center point of circle
                    radius: padding, // this will make it meet our path line
                    startAngle: CGFloat(3*Double.pi/2), // 3π/2 radians = 270 degrees = straight up
                    endAngle: CGFloat(0), // 0 radians = straight right
                    clockwise: true)

        // *********************
        // ***** Right side ****
        // *********************

        // segment 7: line
        path.addLine(to: CGPoint(x: width+padding, y: heightCenter-padding))

        // segment 8: curve
        path.addCurve(to: CGPoint(x: width, y: heightCenter+padding), // ending point
            controlPoint1: CGPoint(x: width+padding, y: heightCenter),
            controlPoint2: CGPoint(x: width, y: heightCenter))

        // segment 9: line
        path.addLine(to: CGPoint(x: width, y: height-padding))
        
        // *********************
        // **** Bottom side ****
        // *********************

        // segment 10: arc
        path.addCurve(to: CGPoint(x: width-padding, y: height), // ending point
            controlPoint1: CGPoint(x: width, y: height),
            controlPoint2: CGPoint(x: width, y: height))

        // segment 11: line
        path.addLine(to: CGPoint(x: xOrigin+padding, y: height))

        // segment 12: arc
        path.addCurve(to: CGPoint(x: xOrigin, y: height-padding), // ending point
            controlPoint1: CGPoint(x: xOrigin, y: height),
            controlPoint2: CGPoint(x: xOrigin, y: height))

        return path
    }
}
