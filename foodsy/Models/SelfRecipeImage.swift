//
//  RecipeImages.swift
//  foodsy
//
//  Created by hsherchan on 11/1/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import Parse

class SelfRecipeImage: PFObject, PFSubclassing {
    @NSManaged var title: String!
    @NSManaged var recipeId: NSNumber!
    @NSManaged var date: NSNumber!
    @NSManaged var customImage: PFFile!
    @NSManaged var customImage1: PFFile!
    @NSManaged var customImage2: PFFile!
    @NSManaged var userName: String!
    
    class func parseClassName() -> String {
        return "SelfRecipeImage"
    }
    
    func saveForUser() {
        self.userName = User.currentUser?.screenname
        self.saveInBackground()
    }
    
    func setImage(image: UIImage?) {
        if self.customImage == nil {
            self.customImage = SelfRecipeImage.getPFFileFromImage(image: image, recipeId: self.recipeId, index: 0)
        } else if self.customImage1 == nil {
            self.customImage1 = SelfRecipeImage.getPFFileFromImage(image: image, recipeId: self.recipeId, index: 1)
        } else if self.customImage2 == nil {
            self.customImage2 = SelfRecipeImage.getPFFileFromImage(image: image, recipeId: self.recipeId, index: 2)
        }
        
    }
    
    func getImage(index: Int, success: @escaping (UIImage?)->(), failure: @escaping (Error)->()) {
        var imageKey = "customImage"
        
        if index > 0 {
            imageKey = "customImage\(index)"
        }
        if let customImage = self.value(forKey: imageKey) as? PFFile {
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
    
    class func fetchByRecipeIdForUser(name: String, recipeId: NSNumber, success: @escaping (SelfRecipeImage?)->()) {
        let query = PFQuery(className: SelfRecipeImage.parseClassName())
        query.whereKey("userName", equalTo: name)
        query.whereKey("recipeId", equalTo: recipeId)
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                let recipeImage = results![0] as! SelfRecipeImage
                success(recipeImage)
            } else {
                success(nil)
            }
        }
    }
    
    class func fetchAllForUser(name: String, success: @escaping ([SelfRecipeImage])->()) {
        let query = PFQuery(className: SelfRecipeImage.parseClassName())
        query.whereKey("userName", equalTo: name)
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                print(results!.count)
                let recipes = results as! [SelfRecipeImage]
                print(recipes)
                success(recipes)
            }
        }
    }
    
    class func getPFFileFromImage(image: UIImage?, recipeId: NSNumber, index: Int) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                let fileName = "recipeimage_\(index)_\(recipeId).png"
                return PFFile(name: fileName, data: imageData)
            }
        }
        return nil
    }
}
