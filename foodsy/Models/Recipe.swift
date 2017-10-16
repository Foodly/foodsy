//
//  Recipe.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import Parse

class Recipe: PFObject, PFSubclassing {
    @NSManaged var vegetarian: NSNumber!
    @NSManaged var vegan: NSNumber!
    @NSManaged var glutenFree: NSNumber!
    @NSManaged var diaryFree: NSNumber!
    @NSManaged var time: NSNumber!
    @NSManaged var timeUnit: String!
    @NSManaged var servings: NSNumber!
    @NSManaged var title: String!
    @NSManaged var imageUrl: String!
    var instructions: [String]!
    @NSManaged var userName: String!
    
    class func parseClassName() -> String {
        return "Recipe"
    }
    
    func favoriteForUser() {
        self.userName = User.currentUser?.screenname
        self.saveInBackground()
    }
    
    class func fetchIngredientsForUser(name: String, success: @escaping ([Recipe])->()) {
        let query = PFQuery(className: Recipe.parseClassName())
        query.whereKey("userName", equalTo: name)
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                let recipes = results as! [Recipe]
                success(recipes)
            }
        }
    }
    
}
