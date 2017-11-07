//
//  RecipeMainIngredientsCardCell.swift
//  foodsy
//
//  Created by hsherchan on 10/18/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeInstructionCardCell: UICollectionViewCell {


    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeView.addShadow()
        recipeView.addCornerRadius(radius: 4.0)
    }

}
