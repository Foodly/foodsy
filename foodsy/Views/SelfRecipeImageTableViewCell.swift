//
//  SelfRecipeImageTableViewCell.swift
//  foodsy
//
//  Created by hsherchan on 11/1/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class SelfRecipeImageTableViewCell: UITableViewCell {

    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeImageView1: UIImageView!
    @IBOutlet weak var recipeImageView2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
