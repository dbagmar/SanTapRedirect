//
//  DemoKeyboard.swift
//

/**
 This protocol is used by the demo application keyboards and
 provides shared functionality.
 
 The demo keyboards are for demo purposes, so they lack some
 functionality, like adapting to other languages, device types etc.
 */
protocol DemoKeyboard {}

extension DemoKeyboard {
    
    static func bottomActions(leftmost: KeyboardAction, for vc: KeyboardParentViewController) -> KeyboardActionRow {
        let actions = [leftmost, switchAction(for: vc), .space, imageAction(for: vc), .newLine]
        let isEmoji = vc.keyboardType == .emojis
        let isImage = vc.keyboardType == .images
 //       let includeImageActions = !isEmoji && !isImage
//        return includeImageActions ? actions : actions.withoutImageActions
        return actions.withoutImageActions
    }
    
    static func bottomActionsCustom(leftmost: KeyboardAction, for vc: KeyboardParentViewController) -> KeyboardActionRow {
        let actions = [leftmost, switchAction(for: vc), .character("Enviar"), imageAction(for: vc), .character("Historial")]
            let isEmoji = vc.keyboardType == .emojis
            let isImage = vc.keyboardType == .images
 //           let includeImageActions = !isEmoji && !isImage
//            return includeImageActions ? actions : actions.withoutImageActions
        return actions.withoutImageActions
    }
    
}

private extension DemoKeyboard {
    static func switchAction(for vc: KeyboardParentViewController) -> KeyboardAction {
        let needsSwitch = vc.needsInputModeSwitchKey
        return needsSwitch ? .switchKeyboard : .switchToKeyboard(.emojis)
    }
    
    static func imageAction(for vc: KeyboardParentViewController) -> KeyboardAction {
        let needsSwitch = vc.needsInputModeSwitchKey
        return needsSwitch ? .switchToKeyboard(.emojis) : .switchToKeyboard(.images)
    }
}

private extension Collection where Element == KeyboardAction {
    
    var withoutImageActions: [KeyboardAction] {
        self.filter { $0 != .switchToKeyboard(.emojis) }
            .filter { $0 != .switchToKeyboard(.images) }
    }
}
