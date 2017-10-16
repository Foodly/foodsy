//
//  RecipeDetailsViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    var recipeID:Int?
    var recipe: Recipe?
    var ingredients: [String]?
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipe?.image != nil {
            self.recipeImageView.setImageWith(URL(string:(recipe?.image)!)!)
        }
        recipeID = recipe?.id as? Int
        RecipeClient.SharedInstance.fetchRecipe(recipeId: recipeID!, success: { (recipe: Recipe) in
            let ingredients = recipe.getIngredients()
            self.displayBulletList(list:ingredients, title: "Ingredients", attributesDictionary: [NSAttributedStringKey.font : self.ingredientsLabel.font] )
        }) { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayBulletList(list: [String], title: String, attributesDictionary: [NSAttributedStringKey : Any]) {
        let fullAttributedString = NSMutableAttributedString(string: "\(title)\n", attributes: attributesDictionary)
        for value in list {
         let bulletPoint: String = "\u{2022}"
         let formattedString: String = "\(bulletPoint) \(value)\n"
         let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
         
         let paragraphStyle = createParagraphAttribute()
         attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green,
         range: NSRange(
         location:0, // Find the location of the bullet and replace it
         length: 1))
         attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
         
         fullAttributedString.append(attributedString)
         
         }
         ingredientsLabel.attributedText = fullAttributedString
    }
    
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: [:])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }

}
