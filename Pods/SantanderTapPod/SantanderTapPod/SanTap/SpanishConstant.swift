//
//  SpanishConstant.swift
//  Teclado
//
//  Created by MCB-Air-036 on 11/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

typealias constantString = Constant.constantString
typealias arrayType = Constant.arrayType
typealias SpanishString = Constant.SpanishString

class Constant {
    
    struct constantString {
        static let Today = "Today"
    }
    
    struct arrayType {
        static let popupCharacterArray = ["A", "C", "D", "E", "I", "O", "U", "N", "S",
                                          "a", "c", "d", "e", "i", "o", "u", "n", "s",
                                          "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                                          "-", "/", "$", "&", "\"",
                                          ".", "?", "!", "´",
                                          "%", "="]
        
        static let rightSideCharacterArray = ["U", "I", "O", "N",
                                              "u", "i", "o", "n",
                                              "9", "0",
                                              "$", "\"",
                                              "´",
                                              "="]
    }

    enum SpanishString: String {
        
        case Today, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday,
        January, February, March, April, May, June, July, August, September, October, November, December
        
        var DisplayString: String {
            switch self {
            case .Today:
                return "Hoy"
            case .Sunday:
                return "Dom"//"Domingo"
            case .Monday:
                return "Lun"//"Lunes"
            case .Tuesday:
                return "Mar"//"Martes"
            case .Wednesday:
                return "Mié"//"Miércoles"
            case .Thursday:
                return "Jue"//"Jueves"
            case .Friday:
                return "Vie"//"Viernes"
            case .Saturday:
                return "Sáb"//"Sábado"
            case .January:
                return "Enero"
            case .February:
                return "Febrero"
            case .March:
                return "Marzo"
            case .April:
                return "Abril"
            case .May:
                return "Mayo"
            case .June:
                return "Junio"
            case .July:
                return "Julio"
            case .August:
                return "Agosto"
            case .September:
                return "Septiembre"
            case .October:
                return "Octubre"
            case .November:
                return "Noviembre"
            case .December:
                return "Diciembre"
            }
        }
        
    }
}
