//
//  Ingredient.swift
//  foodsy
//
//  Created by hsherchan on 10/13/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import Parse

class Ingredient: PFObject, PFSubclassing {
    static var baseUrl = "https://spoonacular.com/cdn/ingredients_100x100/"
    @NSManaged var name: String!
    @NSManaged var image: String!
    @NSManaged var userName: String!
    @NSManaged var type: String!
    @NSManaged var quantity: NSNumber!
    @NSManaged var reminderDays: NSNumber!
    
    class func parseClassName() -> String {
        return "Ingredient"
    }
    
    func getImageUrl() -> URL{
        return URL(string: Ingredient.baseUrl + image)!
    }
    
    func saveForUser() {
        self.name = self.name.capitalized
        self.userName = User.currentUser?.screenname
        self.saveInBackground()
    }
    
    class func fetchIngredientsForUser(name: String, type: String, success: @escaping ([Ingredient])->()) {
        let query = PFQuery(className: Ingredient.parseClassName())
        query.whereKey("userName", equalTo: name)
        query.whereKey("type", equalTo: type)
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                let ingredients = results as! [Ingredient]
                success(ingredients)
            }
        }
    }
    
}
