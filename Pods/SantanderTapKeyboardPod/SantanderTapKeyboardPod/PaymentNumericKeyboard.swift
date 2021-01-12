//
//  PaymentNumericKeyboard.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Pranjal Lamba on 06/02/20.
//

//import KeyboardKit

/**
 This demo keyboard mimicks an English numeric keyboard.
 */
struct PaymentNumericKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardParentViewController) {
        actions = type(of: self).actions(in: viewController)
    }
    
    let actions: KeyboardActionRows
}

private extension PaymentNumericKeyboard {
    
    static func actions(in viewController: KeyboardParentViewController) -> KeyboardActionRows {
        KeyboardActionRows
            .from(characters)
            .appending(EmojiKeyboard.bottomActionsCustom(
            leftmost: switchAction,
            for: viewController))
    }
    
    static let characters: [[String]] = [
        ["1", "2", "3", ],
        ["4", "5", "6", ],
        ["7", "8", "9", ],
        ["C", "0", "⌫",]
    ]
    
    static var switchAction: KeyboardAction {
        .switchToKeyboard(.alphabetic(uppercased: false))
    }
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    
    func addingSideActions() -> [Iterator.Element] {
        var actions = map { $0 }
        actions[3].append(.backspace)
        return actions
    }
}

