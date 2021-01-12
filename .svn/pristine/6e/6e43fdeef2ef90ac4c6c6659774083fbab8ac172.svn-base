//
//  KeyboardCenterButtonRow.swift
//  Teclado
//
//  Created by Darshan Bagmar on 30/03/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
import UIKit

open class KeyboardCenterButtonRow: UIView, KeyboardStackViewComponent {
    
    public convenience init(
        height: CGFloat = .standardKeyboardRowHeight,
        actions: KeyboardActionRow,
        alignment: UIStackView.Alignment = .center,
        distribution: UIStackView.Distribution = .fillProportionally,
        buttonCreator: KeyboardButtonCreator) {
        self.init(frame: .zero)
        self.height = 55
        buttonStackView.alignment = alignment
        buttonStackView.distribution = distribution
        let buttons = actions.map { buttonCreator($0) }
        buttonStackView.addArrangedSubviews(buttons)
    }
    
    public typealias KeyboardButtonCreator = (KeyboardAction) -> (UIView)
    
    public var heightConstraint: NSLayoutConstraint?
    
    public lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 20, y: 0, width: 200, height: 55))
        stackView.axis = .horizontal
        addSubview(stackView, fill: true)
        return stackView
    }()
}
