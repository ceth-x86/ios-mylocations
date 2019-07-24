//
//  String+AddText.swift
//  My Locations
//
//  Created by Andrey Demidov on 24/07/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(text: String?,
                          withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            
            self += text
        }
    }
}
