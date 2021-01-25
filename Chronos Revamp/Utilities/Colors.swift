//
//  Colors.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 1/25/21.
//  Copyright © 2021 Nick Viscomi. All rights reserved.
//

import UIKit

extension UIColor {
    static let schoolYellow = UIColor(red: 0.98, green: 0.87, blue: 0.31, alpha: 1.00)
    static let schoolPurple = UIColor(red: 0.15, green: 0.13, blue: 0.37, alpha: 1.00)
}

func semanticColor(light: UIColor, dark: UIColor) -> UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            } else if traitCollection.userInterfaceStyle == .light {
                return light
            } else {
                return light
            }
        }
    }
    return dark
}
