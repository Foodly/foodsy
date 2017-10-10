//
//  Profile.swift
//  foodsy
//
//  Created by hsherchan on 10/10/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class Profile: NSObject {
    var name: String?
    var currentFoodPref: FoodPreferences?
    
    
    init(name: String?, foodPref: FoodPreferences?) {
        self.name = name
        self.currentFoodPref = foodPref
    }
}
