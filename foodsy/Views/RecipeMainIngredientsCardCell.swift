//
//  RecipeMainIngredientsCardCell.swift
//  foodsy
//
//  Created by hsherchan on 10/18/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeMainIngredientsCardCell: UICollectionViewCell {

    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var mealColorView: UIView!
    @IBOutlet weak var mealColorView1: UIView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var preptimeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsLabel1: UILabel!
    @IBOutlet weak var ingredientsLabel2: UILabel!
    @IBOutlet weak var ingredientsLabel3: UILabel!
    @IBOutlet weak var ingredientsLabel4: UILabel!
    @IBOutlet weak var ingredientsLabel5: UILabel!
    
    @IBOutlet weak var bulletImageView: UIImageView!
    @IBOutlet weak var bulletImageView1: UIImageView!
    @IBOutlet weak var bulletImageView2: UIImageView!
    @IBOutlet weak var bulletImageView3: UIImageView!
    @IBOutlet weak var bulletImageView4: UIImageView!
    @IBOutlet weak var bulletImageView5: UIImageView!
    
    
    var bulletImageViews:[UIImageView]!
    var ingredientLabels:[UILabel]!
    
    var recipe: Recipe! {
        didSet {
            titleLabel.text = recipe.title
            servingsLabel.text = "\(recipe.servings!) servings"
            preptimeLabel.text = "\(recipe.readyInMinutes!) min"
        }
    }
    
    var ingredients: [String]! {
        didSet {
            var i:Int = 0
            
            while i < ingredientLabels.count && i < ingredients.count {
                ingredientLabels[i].text = ingredients[i]
                i = i + 1
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bulletImageView.layer.cornerRadius = bulletImageView.frame.width/2
        bulletImageView.clipsToBounds = true
        
        bulletImageView1.layer.cornerRadius = bulletImageView1.frame.width/2
        bulletImageView1.clipsToBounds = true
        
        bulletImageView2.layer.cornerRadius = bulletImageView2.frame.width/2
        bulletImageView2.clipsToBounds = true
        
        bulletImageView3.layer.cornerRadius = bulletImageView3.frame.width/2
        bulletImageView3.clipsToBounds = true
        
        bulletImageView4.layer.cornerRadius = bulletImageView4.frame.width/2
        bulletImageView4.clipsToBounds = true
        
        bulletImageView5.layer.cornerRadius = bulletImageView5.frame.width/2
        bulletImageView5.clipsToBounds = true
        
        bulletImageViews = [UIImageView]()
        bulletImageViews.append(bulletImageView)
        bulletImageViews.append(bulletImageView1)
        bulletImageViews.append(bulletImageView2)
        bulletImageViews.append(bulletImageView3)
        bulletImageViews.append(bulletImageView4)
        bulletImageViews.append(bulletImageView5)
        
        ingredientLabels = [UILabel]()
        ingredientLabels.append(ingredientsLabel)
        ingredientLabels.append(ingredientsLabel1)
        ingredientLabels.append(ingredientsLabel2)
        ingredientLabels.append(ingredientsLabel3)
        ingredientLabels.append(ingredientsLabel4)
        ingredientLabels.append(ingredientsLabel5)
        
    }

}
