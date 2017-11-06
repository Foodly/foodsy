//
//  RecipeCell.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

@objc protocol FavoriteCellDelegate {
    @objc optional func favoriteCell(favoriteRecipeCell: RecipeCell)
}

class RecipeCell: UITableViewCell {

    @IBOutlet weak var servingsTitleLabel: UILabel!
    @IBOutlet weak var preptimeTitleLabel: UILabel!
    @IBOutlet weak var mealColor: UIView!
    @IBOutlet weak var infoImageView1: UIImageView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var preptimeLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    weak var delegate: FavoriteCellDelegate?
    var recipe: Recipe! {
        didSet {
            self.titleLabel.text = recipe.title
            if let url = URL(string:recipe.image){
                self.foodImageView.setImageWith(url)
            }
            self.preptimeLabel.text = getFormattedTime(timeInMin: recipe.readyInMinutes!)
            self.servingsLabel.text = "\(recipe.servings!)"
            
            if recipe.vegetarian != nil {
                if recipe.vegetarian == 0 {
                    mealColor.backgroundColor = Utils.getMeatColor()
                } else {
                    mealColor.backgroundColor = Utils.getVegetarianColor()
                }
            } else {
                mealColor.backgroundColor = Utils.getNeutralColor()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteBtn.addTarget(self, action: #selector(favoriteBtnClicked), for: UIControlEvents.touchDown)
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        
        
        servingsTitleLabel.addTextSpacing(spacing: 1.5)
        preptimeTitleLabel.addTextSpacing(spacing: 1.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getFormattedTime(timeInMin: NSNumber) -> String {
        let time = timeInMin as! Int
        if time <= 60 {
            return "\(time) min"
        } else if time < 1440 {
            let hours = time/60
            let min = time % 60
            
            if min == 0 {
                if hours > 1 {
                   return "\(hours) hrs"
                } else {
                    return "\(hours) hr"
                }
                
            } else {
                if hours > 1 {
                    return "\(hours) hrs \(min) min"
                } else {
                    return "\(hours) hr \(min) min"
                }
            }
        } else if time >= 1440 {
            let days = time/1440
            let hours = (time - (days * 1440))/60
            
            if hours == 0 {
                if days > 1 {
                    return "\(days) days"
                } else {
                    return "\(days) day"
                }
                
            } else {
                if days > 1{
                    return "\(days) days \(hours) hrs"
                } else {
                    return "\(days) day \(hours) hrs"
                }
                
            }
        }
        
        return ""
    }
    @objc func favoriteBtnClicked(_ button: UIButton) {
        delegate?.favoriteCell!(favoriteRecipeCell: self)
    }
    
    
}
