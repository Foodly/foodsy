//
//  RecipeIngredientsView.swift
//  foodsy
//
//  Created by hsherchan on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeIngredientsView: UIView {
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        recipeIngredientsInit()
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        recipeIngredientsInit()
    }
    
    private func recipeIngredientsInit() {
        Bundle.main.loadNibNamed("RecipeIngredientsView", owner: self, options: nil)
    }
    

}
