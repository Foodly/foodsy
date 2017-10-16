//
//  RecipeCell.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    var recipe: Recipe! {
        didSet {
            self.titleLabel.text = recipe.title
            if recipe.image != nil {
                self.foodImageView.setImageWith(URL(string:recipe.image)!)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
