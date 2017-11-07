//
//  Utils.swift
//  foodsy
//
//  Created by hsherchan on 10/28/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static func getMeatColor() -> UIColor {
        return UIColor(red: 178.0/255.0, green: 59.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    }
    static func getVegetarianColor()  -> UIColor {
        return UIColor(red: 169.0/255.0, green: 216.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    }
    static func getNeutralColor()  -> UIColor{
        return UIColor(red: 246.0/255.0, green: 228.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    }
    static func getTextColor() -> UIColor {
        return UIColor(red: 57.0/255.0, green: 62.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    }
    static func getSecondaryColor() -> UIColor {
        return UIColor(red: 230.0/255.0, green: 232.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
    static func getPrimaryColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 120.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    }
    static func getMissingIngredientColor() -> UIColor {
        return UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    }
    static func getDisabledButtonColor() -> UIColor {
        return UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    }
    static func getDisabledButtonTextColor() -> UIColor {
        return UIColor(red: 195.0/255.0, green: 196.0/255.0, blue: 197.0/255.0, alpha: 1.0)
    }
    static func getTransparentWhiteColor() -> UIColor {
        return UIColor(red: 2555.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0)
    }
}

extension UILabel {
    func addTextSpacing(spacing: CGFloat) {
        if let labelText = text, labelText.characters.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIButton{
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
