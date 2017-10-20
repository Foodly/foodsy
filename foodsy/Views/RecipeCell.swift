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
            if recipe.image != nil {
                self.foodImageView.setImageWith(URL(string:recipe.image)!)
            }
            self.preptimeLabel.text = getFormattedTime(timeInMin: recipe.readyInMinutes!)
            self.servingsLabel.text = "\(recipe.servings!)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteBtn.addTarget(self, action: #selector(favoriteBtnClicked), for: UIControlEvents.touchDown)
        /*cardView.layer.masksToBounds = false;
        cardView.layer.shadowOffset = CGSize(width:CGFloat(-0.2), height:CGFloat(0.2));
        cardView.layer.shadowRadius = 0.5; //%%% I prefer thinner, subtler shadows, but you can play with this
        cardView.layer.shadowOpacity = 0.2; //%%% same thing with this, subtle is better for me
        
        //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
        let path: UIBezierPath = UIBezierPath(rect: cardView.frame)
        cardView.layer.shadowPath = path.cgPath;
        
        // Initialization code*/
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
