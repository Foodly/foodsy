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
    
    @IBOutlet weak var recipeIngredientsView: RecipeIngredientsView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipe?.image != nil {
            self.recipeImageView.setImageWith(URL(string:(recipe?.image)!)!)
        }
        self.recipeIngredientsView.recipe = recipe
        recipeID = recipe?.id as? Int
        RecipeClient.SharedInstance.fetchRecipe(recipeId: recipeID!, success: { (recipe: Recipe) in
            let ingredients = recipe.getIngredients()
            self.recipeIngredientsView.displayBulletList(list: ingredients, title: "", attributesDictionary: [NSAttributedStringKey.font : self.recipeIngredientsView.ingredientsLabel.font] )
        }) { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
