//
//  ApplicationLogger.swift
//  Teclado
//
//  Created by Darshan Bagmar on 29/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
import UIKit

struct ApplicationLoggerConstant {
    static let isLogsEnabled: Bool = false
}
public func printLog(_ items: Any...)  {
    if ApplicationLoggerConstant.isLogsEnabled {
      if  items.count > 0
        {
        for item in items {
             print(item)
        }
        }
    }
  }
