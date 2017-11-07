//
//  RecipeMainIngredientsCardCell.swift
//  foodsy
//
//  Created by hsherchan on 10/18/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import MBProgressHUD

class RecipeMainIngredientsCardCell: UICollectionViewCell {

    @IBOutlet weak var addMissingIngredientsBtn: UIButton!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoImageView1: UIImageView!
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
    
    @IBOutlet weak var ingredientsTitleLabel: UILabel!
    @IBOutlet weak var preptimeTitleLabel: UILabel!
    
    @IBOutlet weak var servingsTitleLabel: UILabel!
    var bulletImageViews:[UIImageView]!
    var ingredientLabels:[UILabel]!
    var missingIngredients = [NSNumber]()
    
    var recipe: Recipe! {
        didSet {
            titleLabel.text = recipe.title
            servingsLabel.text = "\(recipe.servings!) servings"
            preptimeLabel.text = "\(recipe.readyInMinutes!) min"
            
            var recipeIndicatorsCount = 0
            if recipe.dairyFree == 1 {
                recipeIndicatorsCount = recipeIndicatorsCount + 1
                infoImageView.image = UIImage(named: "no-dairy")
            }
            if recipe.glutenFree == 1 {
                if recipeIndicatorsCount == 1 {
                    infoImageView1.image = UIImage(named: "no-gluten")
                } else {
                    infoImageView.image = UIImage(named: "no-gluten")
                    infoImageView1.isHidden = true
                }
            }
        }
    }
    
    var ingredients: [Ingredient]! {
        didSet {
            var i:Int = 0
            
            while i < ingredientLabels.count && i < ingredients.count {
                ingredientLabels[i].text = ingredients[i].name
                i = i + 1
            }
            
            if i < 6 {
                ingredientLabels[i].isHidden = true
                bulletImageViews[i].isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preptimeTitleLabel.addTextSpacing(spacing: 1.15)
        servingsTitleLabel.addTextSpacing(spacing: 1.15)
        ingredientsTitleLabel.addTextSpacing(spacing: 1.15)
        
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        
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
        
        addMissingIngredientsBtn.addTarget(self, action: #selector(addMissingIngredients(_:)), for: .touchUpInside)
        addMissingIngredientsBtn.backgroundColor = Utils.getPrimaryColor()
        addMissingIngredientsBtn.isHidden = true
    }
    
    func changeFonts() {
        titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20.0)
    }
    
    func setAllBulletsAsAdded() {
        for bullet in bulletImageViews {
            bullet.backgroundColor = Utils.getPrimaryColor()
        }
    }
    
    func showDiffBullets(currentIngredients: [Ingredient]) {
        var i:Int = 0
        var currentIngredientsIds = [NSNumber: Bool]()
        
        for ingredient in currentIngredients {
            if ingredient.id != nil {
                currentIngredientsIds[ingredient.id] = true
            }
        }
        
        var showMissingIngredientsButton = false
        missingIngredients = [NSNumber]()
        while i < ingredientLabels.count && i < ingredients.count {
            let listedIngredientId = ingredients[i].id
            if (currentIngredientsIds[listedIngredientId!] != nil) && (currentIngredientsIds[listedIngredientId!] == true)  {
                self.bulletImageViews[i].backgroundColor = Utils.getPrimaryColor()
            } else {
                showMissingIngredientsButton = true
                self.bulletImageViews[i].backgroundColor = Utils.getMissingIngredientColor()
                self.missingIngredients.append(listedIngredientId!)
            }
            i = i + 1
        }
        
        if showMissingIngredientsButton {
            addMissingIngredientsBtn.isHidden = false
        }
    }
    
    @objc func addMissingIngredients(_ sender: UIButton) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = "Adding missing ingredients..."
        IngredientClient.SharedInstance.fetchIngredientByIdInParallel(ingredientIds: self.missingIngredients, success: {
            self.setAllBulletsAsAdded()
            hud.hide(animated: false)
        }) { (error) in
            print(error)
        }
    }

}
