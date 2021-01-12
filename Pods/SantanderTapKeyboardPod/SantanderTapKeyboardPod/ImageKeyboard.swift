//
//  ImageKeyboard.swift
//

/**
 
 This demo keyboard has 24 buttons per page, which fits this
 demo app's two different grid sizes for portrait/landscape.
 It features one page of real emoji characters and four with
 image buttons, which are handled by the demo action handler.
 
 If you make any changes to this keyboard (which you should,
 play with it) the keyboard may get an uneven set of buttons,
 which the grid engine handles by adding empty dummy buttons
 at the very end.
 
 */
struct ImageKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardParentViewController) {
        self.bottomActions = EmojiKeyboard.bottomActionsCustom(
            leftmost: EmojiKeyboard.switchAction,
            for: viewController)
    }
    
    let actions: [KeyboardAction] = [
    .character("Historial")
    ]
    
    let bottomActions: KeyboardActionRow
}

private extension EmojiKeyboard {
    
    static var switchAction: KeyboardAction {
        .switchToKeyboard(.alphabetic(uppercased: false))
    }
}
