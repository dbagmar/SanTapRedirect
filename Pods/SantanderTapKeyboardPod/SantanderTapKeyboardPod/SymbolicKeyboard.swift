//
//  SymbolicKeyboard.swift
//

/**
 This demo keyboard mimicks an English symbolic keyboard.
 */
struct SymbolicKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardParentViewController) {
        actions = type(of: self).actions(in: viewController)
    }
    
    let actions: KeyboardActionRows
}

private extension SymbolicKeyboard {
    
    static func actions(in viewController: KeyboardParentViewController) -> KeyboardActionRows {
        KeyboardActionRows
            .from(characters)
            .addingSideActions()
            .appending(bottomActions(leftmost: switchAction, for: viewController))
    }
    
    static var characters: [[String]] = [
        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
        [".", ",", "?", "!", "´"]
    ]
    
    static var switchAction: KeyboardAction {
        .switchToKeyboard(.alphabetic(uppercased: false))
    }
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    
    func addingSideActions() -> [Iterator.Element] {
        var actions = map { $0 }
        actions[2].insert(.switchToKeyboard(.numeric), at: 0)
        actions[2].insert(.none, at: 1)
        actions[2].append(.none)
        actions[2].append(.backspace)
        return actions
    }
}
