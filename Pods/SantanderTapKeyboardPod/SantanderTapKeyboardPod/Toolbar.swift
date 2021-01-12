//
//  Toolbar.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Pranjal Lamba on 08/02/20.
//

import CoreGraphics
import UIKit
//import KeyboardKit

/**
 This toolbar can be used to present autocomplete suggestion
 words while the user types.
 
 Since the `buttonCreator` parameter can return any view for
 any string, you can use this class to present any views you
 want, given any custom list of words.
 */
public class Toolbar: KeyboardToolbar {

    
    // MARK: - Initialization

    /**
     Create an autocomplete toolbar that has a custom button
     creation function.
     */
    public init(
        height: CGFloat = .standardKeyboardRowHeight,
        buttonCreator: @escaping ButtonCreator,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fillEqually) {
        self.buttonCreator = buttonCreator
        super.init(height: height, alignment: alignment, distribution: distribution)
        stackView.spacing = 0
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor).isActive = true
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .leading
    }
    
    /**
     Create an autocomplete toolbar that uses standard label
     classes of type `AutocompleteToolbarLabel` to provide a
     way to send suggestions to a `UITextDocumentProxy`.
     */
    public convenience init(
        height: CGFloat = .standardKeyboardRowHeight,
        textDocumentProxy: UITextDocumentProxy,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fillEqually) {
        self.init(
            height: height,
            buttonCreator: { ToolbarLabel(text: $0, textDocumentProxy: textDocumentProxy) },
            alignment: alignment,
            distribution: distribution
        )
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Types
    
    public typealias ButtonCreator = (String) -> (UIView)

    
    // MARK: - Properties
    
    private let buttonCreator: ButtonCreator
    
    private var suggestions: [String] = [] {
        didSet {
            if oldValue == suggestions { return }
            let buttons = suggestions.map { buttonCreator($0) }
            stackView.removeAllArrangedSubviews()
            stackView.addArrangedSubviews(buttons)
        }
    }
    
    
    // MARK: - Functions
    
    /**
     Reset the toolbar by removing all suggestions.
     */
    public func reset() {
        update(with: [])
    }
    
    /**
     Update the toolbar with new words. This will remove all
     previously added views from the stack view and create a
     new set of views for the new word collection.
     */
    public func update(with suggestions: [String]) {
        self.suggestions = suggestions
    }
}

