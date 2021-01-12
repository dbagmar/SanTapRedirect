//
//  UIView+ActionLongPressGesture.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2017-12-12.
//  Copyright © 2017 Daniel Saidi. All rights reserved.
//
//  Reference: https://medium.com/@sdrzn/adding-gesture-recognizers-with-closures-instead-of-selectors-9fb3e09a8f0b
//

/*
 This extension applies long press gesture recognizers using
 action blocks instead of a target and a selector.
 */

import UIKit

public extension UIView {
    
    typealias LongPressAction = (() -> Void)
    
    /**
     Add a long press gesture recognizer to the view.
     */
    func addLongPressAction(action: @escaping LongPressAction) {
        longPressAction = action
        isUserInteractionEnabled = true
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressAction))
        recognizer.minimumPressDuration = 0.5
        addGestureRecognizer(recognizer)
    }
    
    /**
     Remove all long press gesture recognizers from the view.
     */
    func removeLongPressAction() {
        gestureRecognizers?
            .filter { $0 is UILongPressGestureRecognizer }
            .forEach { removeGestureRecognizer($0) }
    }
}

private extension UIView {
    
    struct Key { static var id = "longPressAction" }
    
    var longPressAction: LongPressAction? {
        get {
            return objc_getAssociatedObject(self, &Key.id) as? LongPressAction
        }
        set {
            guard let value = newValue else { return }
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            objc_setAssociatedObject(self, &Key.id, value, policy)
        }
    }
    
    @objc func handleLongPressAction(sender: UILongPressGestureRecognizer) {
        
        superview?.bringSubviewToFront(self)
        
        if sender.state == .began {
            if let button = self as? DemoButton {
                switch button.action {
                case .character:
                    printLog("Long-Tap :", button.textLabel?.text ?? "")
                    
                    if let buttontext = button.textLabel?.text {
                        UserDefaults.standard.set(buttontext, forKey: "SelectedCharString")
                    }
                    var letterArray = button.action.popupCharacterOptions()
                    UserDefaults.standard.set(letterArray, forKey: "LetterArray")
                    if letterArray.count == 1,  letterArray[0] == "" {
                        letterArray.removeAll()
                        letterArray.insert(button.textLabel!.text!, at: 0)
                    }
                    addKeyboardPopupLayer(letterarray: letterArray)
                    
                case .shift:
                    break
                case .shiftDown:
                    break
                default:
                    return
                }
            }
        } else if sender.state == .changed {
            if let button = self as? DemoButton {
                switch button.action {
                case .character:
                    if let array = UserDefaults.standard.object(forKey: "LetterArray") {
                        var popupKeyArray = array as! [String]
                        
                        // If Array Contains only Vowel Then only highlight the color of Label
                        popupKeyArray = popupKeyArray.filter { arrayType.popupCharacterArray.contains($0) }
                        if popupKeyArray.count >= 1 {
                            
                            guard let foundView = self.viewWithTag(1003) else {return}
                            if foundView.bounds.contains(sender.location(in: foundView)) { // Get the location of touch from PopupView
                                for view in foundView.subviews {
                                    
                                    // If it has Label with Vowel character then change Background & Text color of label
                                    if view is UILabel {
                                        let label = view as! UILabel
                                        if ((sender.location(in: foundView).x > view.frame.minX) && (sender.location(in: foundView).x < view.frame.maxX)) {
                                            label.backgroundColor = .systemBlue
                                            label.textColor = .white
                                            printLog("Selected_String",label.text as Any)
                                            UserDefaults.standard.set(label.text, forKey: "SelectedCharString")
                                        }else{
                                            label.backgroundColor = .clear
                                            label.textColor = .black
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                case .shift:
                    break
                case .shiftDown:
                    break
                default:
                    return
                }
            }
            
        } else if sender.state == .ended {
            if let button = self as? DemoButton {
                switch button.action {
                case .character:
                    if let selectedCharacter = UserDefaults.standard.object(forKey: "SelectedCharString") {
                        UserDefaults.standard.set(nil, forKey: "LetterArray")
                        
                        let sectedString = selectedCharacter as! String
                        printLog("Final_String", sectedString)
                    }
                    longPressAction?()
                    guard let foundView = self.viewWithTag(1003) else {return}
                    for view in foundView.subviews {
                        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                        view.removeFromSuperview()
                    }
                    foundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                    foundView.removeFromSuperview()
                    
                case .shift:
                    break
                case .shiftDown:
                    break
                default:
                    return
                }
            }
            
            
        }
    }
    
    func addKeyboardPopupLayer(letterarray: [String]) {
        
        let xpadding = CGFloat(3.0)
        let ypadding = CGFloat(3.0)
        
        var viewOrigin_x = CGFloat(0.0) + xpadding
        let viewOrigin_y = -self.frame.size.height
        var viewSize_width = ((self.frame.size.width) * CGFloat(letterarray.count)) - (2*xpadding)
        let viewSize_height = (self.frame.size.height*2) - (2*ypadding)
        
        let rightKeyArray = letterarray.filter { arrayType.rightSideCharacterArray.contains($0) }
        if rightKeyArray.contains("O") || rightKeyArray.contains("o") || rightKeyArray.contains("9"){
            viewOrigin_x = -(((self.frame.size.width) * CGFloat(letterarray.count) - 2*(self.frame.size.width)) - (xpadding))
            viewSize_width = (((self.frame.size.width) * CGFloat(letterarray.count)) - (2*xpadding)) - (xpadding)
        } else if rightKeyArray.count>=1 {
            viewOrigin_x = -(((self.frame.size.width) * CGFloat(letterarray.count) - (self.frame.size.width)) - (xpadding))
            viewSize_width = (((self.frame.size.width) * CGFloat(letterarray.count)) - (2*xpadding))
        }
                
        let keyView = UIView(frame: CGRect(x: viewOrigin_x, y: viewOrigin_y, width: viewSize_width, height: viewSize_height))
        keyView.backgroundColor = .clear
        keyView.tag = 1003
        self.addSubview(keyView)
        
        let keyView_x = keyView.bounds.origin.x
        let keyView_y = keyView.bounds.origin.y
        let keyView_width = keyView.bounds.size.width
        let keyView_height = keyView.bounds.size.height
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "PopUpLayer"
        shapeLayer.position = CGPoint(x: 0, y: 0)
        if rightKeyArray.contains("O") || rightKeyArray.contains("o") || rightKeyArray.contains("9"){
            shapeLayer.path = createLeftRightBezierPath(xOrigin: keyView_x, yOrigin: keyView_y, width: keyView_width, height: keyView_height, letters: letterarray).cgPath
        } else if rightKeyArray.count>=1 {
            shapeLayer.path = createRightBezierPath(xOrigin: keyView_x, yOrigin: keyView_y, width: keyView_width, height: keyView_height, letters: letterarray).cgPath
        } else {
            shapeLayer.path = createLeftBezierPath(xOrigin: keyView_x, yOrigin: keyView_y, width: keyView_width, height: keyView_height, letters: letterarray).cgPath
        }
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.borderWidth = 0.05
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shapeLayer.shadowRadius = 5
        shapeLayer.shadowOpacity = 0.5
        keyView.layer.addSublayer(shapeLayer)
        
        let popupLabel_padding = CGFloat(7)
        var popupLabel_origin_x = CGFloat(0.0)
        let popupLabel_width = keyView_width/CGFloat(letterarray.count)
        let popupLabel_height = (keyView_height/2) - (2*popupLabel_padding)
        var viewCount = CGFloat(0.0)
        let popupKeyArray = letterarray.filter { arrayType.popupCharacterArray.contains($0) }
        
        for characterString in letterarray {
            popupLabel_origin_x = (viewCount * popupLabel_width)
            viewCount = viewCount+1
            
            let vowelLabel = UILabel(frame: CGRect(x: popupLabel_origin_x, y: popupLabel_padding, width: popupLabel_width, height: popupLabel_height))
            vowelLabel.font = vowelLabel.font.withSize(32)
            if popupKeyArray.count>=1 {
//                vowelLabel.font = UIFont(name: "Helvetica-Regular", size: 25.0)
                vowelLabel.font = vowelLabel.font.withSize(20)
            }
            vowelLabel.text = characterString
            vowelLabel.tag = Int(viewCount)
            vowelLabel.textColor = .black
            vowelLabel.backgroundColor = .clear
            vowelLabel.textAlignment = .center
            vowelLabel.contentMode = .center
            vowelLabel.baselineAdjustment = .alignCenters
            vowelLabel.lineBreakMode = .byClipping
            vowelLabel.layer.cornerRadius = 5
            vowelLabel.clipsToBounds = true
            keyView.addSubview(vowelLabel)
        }
        
    }
    
    func createLeftBezierPath(xOrigin:CGFloat, yOrigin:CGFloat, width:CGFloat, height:CGFloat, letters:[String]) -> UIBezierPath {
        
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

        if letters.count == 1 {
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
        } else {
            // segment 8: arc
            let baseViewWidth = (width/CGFloat(letters.count))-3
            path.addArc(withCenter: CGPoint(x: width, y: heightCenter-padding), // center point of circle
                radius: padding, // this will make it meet our path line
                startAngle: CGFloat(0),  //0 radians = 0 degrees = straight Right
                endAngle: CGFloat(Double.pi/2),  //Double.pi/2 radians = 90 degrees = straight Down
                clockwise: true)

            
            // segment 9: line
            path.addLine(to: CGPoint(x: baseViewWidth+padding, y: heightCenter))

            path.addCurve(to: CGPoint(x: baseViewWidth, y: heightCenter+padding), // ending point
                controlPoint1: CGPoint(x: baseViewWidth, y: heightCenter),
                controlPoint2: CGPoint(x: baseViewWidth, y: heightCenter))
            
            path.addLine(to: CGPoint(x: baseViewWidth, y: height-padding))
            
            // *********************
            // **** Bottom side ****
            // *********************
            
            // segment 10: arc
            path.addCurve(to: CGPoint(x: baseViewWidth-padding, y: height), // ending point
                controlPoint1: CGPoint(x: baseViewWidth, y: height),
                controlPoint2: CGPoint(x: baseViewWidth, y: height))
        }
        
        // segment 11: line
        path.addLine(to: CGPoint(x: xOrigin+padding, y: height))
        
        // segment 12: arc
        path.addCurve(to: CGPoint(x: xOrigin, y: height-padding), // ending point
            controlPoint1: CGPoint(x: xOrigin, y: height),
            controlPoint2: CGPoint(x: xOrigin, y: height))
        
        return path
    }
    
    func createRightBezierPath(xOrigin:CGFloat, yOrigin:CGFloat, width:CGFloat, height:CGFloat, letters:[String]) -> UIBezierPath {
        
        let heightCenter = height/2
        let padding : CGFloat = 10
        
        // create a new path
        let path = UIBezierPath()
        
        // starting point for the path (bottom left)
        path.move(to: CGPoint(x: width, y: height-padding))
        
        // *********************
        // ***** Left side *****
        // *********************
        
        // segment 1: line
        path.addLine(to: CGPoint(x: width, y: heightCenter+padding))
        
        // segment 2: curve
        path.addCurve(to: CGPoint(x: width+padding, y: heightCenter-padding), // ending point
            controlPoint1: CGPoint(x: width, y: heightCenter),
            controlPoint2: CGPoint(x: width+padding, y: heightCenter))
        
        // segment 3: line
        path.addLine(to: CGPoint(x: width+padding, y: yOrigin+padding))
        
        // *********************
        // ****** Top side *****
        // *********************
        
        // segment 4: arc
        path.addArc(withCenter: CGPoint(x: width, y: yOrigin+padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(0), // 0 radians = straight right
            endAngle: CGFloat(3*Double.pi/2), // 3π/2 radians = 270 degrees = straight up
            clockwise: false)
        
        
        // segment 5: line
        path.addLine(to: CGPoint(x: xOrigin, y: yOrigin))
        
        // segment 6: arc
        path.addArc(withCenter: CGPoint(x: xOrigin, y: yOrigin+padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(3*Double.pi/2), // 3π/2 radians = 270 degrees = straight up
            endAngle: CGFloat(Double.pi), // π radians = 180 degrees = straight left
            clockwise: false)
        
        // *********************
        // ***** Right side ****
        // *********************
        
        // segment 7: line
        path.addLine(to: CGPoint(x: xOrigin-padding, y: heightCenter-padding))
        
        // segment 8: arc
        let baseViewWidth = (width/CGFloat(letters.count))-3
        path.addArc(withCenter: CGPoint(x: xOrigin, y: heightCenter-padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(Double.pi), // π radians = 180 degrees = straight left
            endAngle: CGFloat(Double.pi/2),  //Double.pi/2 radians = 90 degrees = straight Down
            clockwise: false)
        
        
        // segment 9: line
        path.addLine(to: CGPoint(x: (width-baseViewWidth)-padding, y: heightCenter))
        
        path.addCurve(to: CGPoint(x: width-baseViewWidth, y: heightCenter+padding), // ending point
            controlPoint1: CGPoint(x: width-baseViewWidth, y: heightCenter),
            controlPoint2: CGPoint(x: width-baseViewWidth, y: heightCenter))
        
        path.addLine(to: CGPoint(x: width-baseViewWidth, y: height-padding))
        
        // *********************
        // **** Bottom side ****
        // *********************
        
        // segment 10: arc
        path.addCurve(to: CGPoint(x: (width-baseViewWidth)+padding, y: height), // ending point
            controlPoint1: CGPoint(x: width-baseViewWidth, y: height),
            controlPoint2: CGPoint(x: width-baseViewWidth, y: height))
        
        // segment 11: line
        path.addLine(to: CGPoint(x: width-padding, y: height))
        
        // segment 12: arc
        path.addCurve(to: CGPoint(x: width, y: height-padding), // ending point
            controlPoint1: CGPoint(x: width, y: height),
            controlPoint2: CGPoint(x: width, y: height))
        
        return path
    }
    
    func createLeftRightBezierPath(xOrigin:CGFloat, yOrigin:CGFloat, width:CGFloat, height:CGFloat, letters:[String]) -> UIBezierPath {
        
        let heightCenter = height/2
        let padding : CGFloat = 10
        var baseViewWidth = (width/CGFloat(letters.count))-3
        
        if letters.contains("9") {
            baseViewWidth = (CGFloat(width-3)/CGFloat(letters.count))
        }
        // create a new path
        let path = UIBezierPath()
        
        // starting point for the path (bottom left)
        path.move(to: CGPoint(x: width-baseViewWidth, y: height-padding))
        
        // *********************
        // ***** Left side *****
        // *********************
        
        // segment 1: line
        path.addLine(to: CGPoint(x: width-baseViewWidth, y: heightCenter+padding))
        
        // segment 2: curve
        path.addCurve(to: CGPoint(x: (width-baseViewWidth)+padding, y: heightCenter), // ending point
            controlPoint1: CGPoint(x: (width-baseViewWidth), y: heightCenter),
            controlPoint2: CGPoint(x: (width-baseViewWidth), y: heightCenter))

        // segment 3: line
        path.addLine(to: CGPoint(x: width-padding, y: heightCenter))

        // segment 4: arc
        path.addArc(withCenter: CGPoint(x: width, y: (heightCenter) - padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(Double.pi/2), // π/2 radians = 90 degrees = straight Down
            endAngle: CGFloat(0), // 0 radians = straight right
            clockwise: false)

        // *********************
        // ****** Top side *****
        // *********************

        // segment 5: line
        path.addLine(to: CGPoint(x: width+padding, y: yOrigin+padding))

        // segment 6: arc
        path.addArc(withCenter: CGPoint(x: width, y: yOrigin+padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(0), // 0 radians = straight right
            endAngle: CGFloat(3*Double.pi/2), // 3π/2 radians = 270 degrees = straight up
            clockwise: false)

        // segment 7: line
        path.addLine(to: CGPoint(x: xOrigin-padding, y: yOrigin))

        // segment 6: arc
        path.addArc(withCenter: CGPoint(x: xOrigin, y: yOrigin+padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(3*Double.pi/2), // 3π/2 radians = 270 degrees = straight up
            endAngle: CGFloat(Double.pi), // π radians = 180 degrees = straight left
            clockwise: false)

        // *********************
        // ***** Right side ****
        // *********************

        // segment 7: line
        path.addLine(to: CGPoint(x: xOrigin-padding, y: heightCenter-padding))

        // segment 8: arc
        path.addArc(withCenter: CGPoint(x: xOrigin, y: heightCenter-padding), // center point of circle
            radius: padding, // this will make it meet our path line
            startAngle: CGFloat(Double.pi), // π radians = 180 degrees = straight left
            endAngle: CGFloat(Double.pi/2),  //Double.pi/2 radians = 90 degrees = straight Down
            clockwise: false)


        // segment 9: line
        path.addLine(to: CGPoint(x: (width-2*baseViewWidth)-padding, y: heightCenter))

        path.addCurve(to: CGPoint(x: width-2*baseViewWidth, y: heightCenter+padding), // ending point
            controlPoint1: CGPoint(x: width-2*baseViewWidth, y: heightCenter),
            controlPoint2: CGPoint(x: width-2*baseViewWidth, y: heightCenter))

        path.addLine(to: CGPoint(x: width-2*baseViewWidth, y: height-padding))

        // *********************
        // **** Bottom side ****
        // *********************

        // segment 10: arc
        path.addCurve(to: CGPoint(x: (width-2*baseViewWidth)+padding, y: height), // ending point
            controlPoint1: CGPoint(x: width-2*baseViewWidth, y: height),
            controlPoint2: CGPoint(x: width-2*baseViewWidth, y: height))

        // segment 11: line
        path.addLine(to: CGPoint(x: (width-baseViewWidth)-padding, y: height))

        // segment 12: arc
        path.addCurve(to: CGPoint(x: width-baseViewWidth, y: height-padding), // ending point
            controlPoint1: CGPoint(x: width-baseViewWidth, y: height),
            controlPoint2: CGPoint(x: width-baseViewWidth, y: height))
        
        return path
    }

}
