//
//  EPColorHelper.swift
//  emopot
//
//  Created by BluesJiang on 2018/5/14.
//  Copyright © 2018年 Unique Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(red:UInt8, green:UInt8, blue:UInt8 ) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
    convenience init(bgrHex: UInt32) {
        let b = CGFloat((bgrHex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((bgrHex & 0x00FF00) >> 8) / 255.0
        let r = CGFloat((bgrHex & 0x0000FF) ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    
    public convenience init(assHex:String) {
        let hexString:String
        if assHex.starts(with: "#") {
            hexString = String(assHex[assHex.index(after: assHex.startIndex) ..< assHex.endIndex])
        } else {
            hexString = assHex
        }
        var hexValue:UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&hexValue)
        self.init(bgrHex: hexValue)
    }
    
    public var hexForASS:String {
        let red = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let green = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let blue = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        getRed(red, green: green, blue: blue, alpha: nil)
        let redValue = Int(red.pointee * 255)
        let greenValue = Int(green.pointee * 255)
        let blueValue = Int(green.pointee * 255)
        return String(format: "&H00%02x%02x%02x", blueValue, greenValue, redValue).uppercased()
    }
    
    static var tintGreen:UIColor {
        return UIColor(red: 141, green: 248, blue: 159)
    }
    static var backgroundDark:UIColor {
        return UIColor(red: 44, green: 48, blue: 51)
    }
    static var placeholderGray:UIColor {
        return UIColor(red: 181, green: 181, blue: 181)
    }
    static var snow:UIColor {
        return UIColor(red: 255, green: 250, blue: 250)
    }
    static var snowH:UIColor {
        return UIColor(red: 238/255, green: 233/255, blue: 233/255,alpha: 1)
    }
    static var addV:UIColor {
        return UIColor(red: 190/255, green: 190/255, blue: 190/255,alpha: 0.5)
    }
    static var rose:UIColor {
        return UIColor(red: 205, green: 155, blue: 155)
    }
    static var seasell:UIColor {
        return UIColor(red: 139, green: 134, blue: 130)
    }
    static var tintDark:UIColor {
        return UIColor(red: 16, green: 23, blue: 28)
    }
    
    static var darkCoral:UIColor {
        return UIColor(red: 209, green: 83, blue: 80)
    }
    
    
    
    static var errorRed:UIColor {
        return UIColor(red: 209, green: 83, blue: 80)
    }
    
    static var disableGray:UIColor {
        return UIColor(red: 74, green: 81, blue: 86)
    }
    
    static var backgroundWhite:UIColor {
        return UIColor(red: 241, green: 245, blue: 253)
    }
    
    static var tintPurple:UIColor {
        return UIColor(red: 124, green: 76, blue: 235)
    }
    static var tintGray:UIColor {
        return UIColor(red: 187, green: 203, blue: 215)
    }
    
    static var buttonBackgroundDark:UIColor {
        return UIColor(red: 64, green: 70, blue: 74)
    }
    
    static var paletteColors:[UIColor] {
        return [
            UIColor(red: 139, green: 213, blue: 81),
            UIColor(red: 86, green: 135, blue: 238),
            UIColor(red: 124, green: 76, blue: 235),
            UIColor(red: 255, green: 168, blue: 206),
            UIColor(red: 235, green: 143, blue: 76),
            UIColor(red: 19, green: 209, blue: 144),
            UIColor(red: 234, green: 104, blue: 162),
            UIColor(red: 211, green: 104, blue: 234),
            UIColor(red: 232, green: 187, blue: 78),
            UIColor(red: 128, green: 195, blue: 200)
        ]
    }
    
}
