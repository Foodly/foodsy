//
//  Filters.swift
//  foodsy
//
//  Created by hsherchan on 10/29/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class Filters: NSObject {
    static let sharedInstance = Filters()
    
    var dietSelectState = 0
    var typeSelectState = 0
    var intolerancesSwitchStates = [Int: Bool]()
    var cuisineSwitchStates = [Int: Bool]()
}
