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
    @NSManaged var title: String!
    @NSManaged var image: String!
    @NSManaged var userName: String!
    @NSManaged var analyzedInstructions: [NSDictionary]!
    @NSManaged var id: NSNumber!
    @NSManaged var extendedIngredients: [NSDictionary]?
    @NSManaged var readyInMinutes: NSNumber!
    @NSManaged var servings: NSNumber!
    
    class func parseClassName() -> String {
        return "Recipe"
    }
    
    func favoriteForUser() {
        self.userName = User.currentUser?.screenname
        self.saveInBackground()
    }
    
    func getIngredients() -> [String] {
        var ingredients = [String]()
        let instructions = self.extendedIngredients as! [NSDictionary]
        
        for step in instructions {
            let original = step["originalString"] as! String
            ingredients.append(original)
        }
        return ingredients
    }
    
    class func fetchFavoriteRecipesForUser(name: String, success: @escaping ([Recipe])->()) {
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
