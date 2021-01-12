//
//  CustomKeyboard.swift
//  Teclado
//
//  Created by Darshan Bagmar on 30/03/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

struct CustomKeyboard: DemoKeyboard {
    
    init(uppercased: Bool, in viewController: KeyboardParentViewController) {
        actions = CustomKeyboard.actions(uppercased: uppercased, in: viewController)
    }
    
    let actions: KeyboardActionRows
    let action: [KeyboardAction] = [
        .image(description: "BackArrowCircle", keyboardImageName: "stap_BackArrowCircle", imageName: "stap_BackArrowCircle"),
        .image(description: "appRed", keyboardImageName: "stap_appRed", imageName: "stap_appRed"),
        .image(description: "enviarSelected", keyboardImageName: "stap_enviarSelected", imageName: "stap_enviarSelected"),
        //.image(description: "servicios", keyboardImageName: "Servicess", imageName: "Servicess"),
       // .image(description: "atm", keyboardImageName: "ATMs", imageName: "ATMs"),
        .image(description: "KeyboardWork", keyboardImageName: "stap_Keyboard", imageName: "stap_Keyboard"),
    ]
    
    let historyaction: [KeyboardAction] = [
        .image(description: "BackArrowCircle", keyboardImageName: "stap_BackArrowCircle", imageName: "stap_BackArrowCircle"),
        .image(description: "app", keyboardImageName: "stap_app", imageName: "stap_app"),
        .image(description: "enviarUnselected", keyboardImageName: "stap_enviarUnselected", imageName: "stap_enviarUnselected"),
        //.image(description: "servicios", keyboardImageName: "Servicess", imageName: "Servicess"),
       // .image(description: "atm", keyboardImageName: "ATMs", imageName: "ATMs"),
        .image(description: "KeyboardWork", keyboardImageName: "stap_Keyboard", imageName: "stap_Keyboard"),
    ]
    
    let bottomaction: [KeyboardAction] = [
        .character("Enviar")
    ]
}

extension CustomKeyboard {
    
    static func actions( uppercased: Bool, in viewController: KeyboardParentViewController) -> KeyboardActionRows {
        KeyboardActionRows.from(characters).appending(EmojiKeyboard.bottomActionsCustom(leftmost: switchAction, for: viewController))
    }

    static let characters: [[String]] = [["1", "2", "3", "4", "5"],
                                         ["6", "7", "8", "9", "0"]]
    
    static var switchAction: KeyboardAction {
        .switchToKeyboard(.numeric)
    }
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    
    func addingSideActions() -> [Iterator.Element] {
        var actions = map { $0 }
        actions[3].append(.backspace)
        return actions
    }
}
