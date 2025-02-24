//
//  UIColor+Hex.swift
//  Todoey
//
//  Created by Jeff Patterson on 2/4/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//
// https://ditto.live/blog/swift-hex-color-extension

import Foundation
import UIKit

extension UIColor {
    // Convert the hex string version of a UIColor into a usable format
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        let scanner = Scanner(string: hexString)
        
        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else {
            return nil
        }
        
        var red, green, blue, alpha: UInt64
        switch hexString.count {
            case 6:
                red = (rgbValue >> 16)
                green = (rgbValue >> 8 & 0xFF)
                blue = (rgbValue & 0xFF)
                alpha = 255
            case 8:
                red = (rgbValue >> 16)
                green = (rgbValue >> 8 & 0xFF)
                blue = (rgbValue & 0xFF)
                alpha = rgbValue >> 24
            default:
                return nil
        }
        
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    
    // Return the hex value of the UIColor as a string
    func toHexString(includeAlpha: Bool = false) -> String? {
        // Get the individual rgba components of the UIColor
        guard let components = self.cgColor.components else {
            // If the UIColor's color space doesn't support RGB components, return nil
            return nil
        }
        
        // Convert the rgb parts to ints
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        // Create a hex string with the RGB values and, optionally, the alpha value
        let hexString: String
        if includeAlpha, let alpha = components.last {
            let alphaValue = Int(alpha * 255.0)
            hexString = String(format: "#%02X%02X%02X%02X", red, green, blue, alphaValue)
        } else {
            hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }
        
        // Return the hex string
        return hexString
    }
    
    
}


