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
    @NSManaged var customImage: PFFile!
    
    class func parseClassName() -> String {
        return "Ingredient"
    }
    
    func getImageUrl() -> URL?{
        if image != nil {
            return URL(string: Ingredient.baseUrl + image)!
        }
        return nil
    }
    
    func saveForUser() {
        self.name = self.name.capitalized
        self.userName = User.currentUser?.screenname
        self.saveInBackground()
    }
    
    func setImage(image: UIImage?) {
        self.customImage = Ingredient.getPFFileFromImage(image: image)
    }
    
    func getImage(success: @escaping (UIImage?)->(), failure: @escaping (Error)->()) {
        if let customImage = self.value(forKey: "customImage") as? PFFile {
            customImage.getDataInBackground(block: { (imageData, error) in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    success(image)
                } else if error != nil {
                    failure(error!)
                } else {
                    print("no error, no success :(")
                }
            })
        } else {
            success(nil)
        }
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
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}
