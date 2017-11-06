//
//  RecipeMainIngredientsCardCell.swift
//  foodsy
//
//  Created by hsherchan on 10/18/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeInstructionCardCell: UICollectionViewCell {


    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
    }

}
