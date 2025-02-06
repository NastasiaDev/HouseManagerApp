//
//  AppColors.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

enum AppColors {
        static let blueMain = UIColor().hex(0x00339C)
        static let grayBorder = UIColor().hex(0xB2B2B2)
        static let orangeBtn = UIColor().hex(0xFFBE60)
}

extension UIColor {
    func hex(_ rgbValue: UInt64) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
