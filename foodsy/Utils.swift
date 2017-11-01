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
        return UIColor(red: 187.0/255.0, green: 63.0/255.0, blue: 77.0/255.0, alpha: 1.0)
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
        return UIColor(red: 255.0/255.0, green: 131.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
}
