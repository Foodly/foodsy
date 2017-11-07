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
    @NSManaged var dairyFree: NSNumber!
    @NSManaged var glutenFree: NSNumber!
    @NSManaged var vegetarian: NSNumber!
    @NSManaged var sourceUrl: String!
    
    class func parseClassName() -> String {
        return "Recipe"
    }
    
    func favoriteForUser() {
        self.userName = User.currentUser?.screenname
        self.saveInBackground()
    }
    
    func unfavoriteForUser() {
        self.userName = User.currentUser?.screenname
        self.deleteInBackground()
    }
    
    func getIngredients() -> [Ingredient] {
        var ingredients = [Ingredient]()
        let instructions = self.extendedIngredients as! [NSDictionary]
        
        for step in instructions {
            let original = step["originalString"] as! String
            let ingredientId = step["id"] as! NSNumber
            let ingredient = Ingredient()
            ingredient.id = ingredientId
            ingredient.name = original
            ingredients.append(ingredient)
        }
        return ingredients
    }
    
    
    func getInstructions() -> [String] {
        var instructions = [String]()
        print(self.analyzedInstructions)
        let firstPart = self.analyzedInstructions[0]
        let steps = firstPart["steps"] as! [NSDictionary]
        for step in steps {
            let stepInstruction = step["step"] as! String
            instructions.append(stepInstruction)
        }
        
        return instructions
    }
    
    class func fetchFavoriteRecipesForUser(name: String, success: @escaping ([Recipe]?)->()) {
        let query = PFQuery(className: Recipe.parseClassName())
        query.whereKey("userName", equalTo: name)
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                let recipes = results as! [Recipe]
                success(recipes)
            } else {
                success(nil)
            }
        }
    }
    
}
