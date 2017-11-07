//
//  IngredientTableViewCell.swift
//  foodsy
//
//  Created by drishi on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import SwipeCellKit

@objc protocol IngredientTableViewCellDelegate {
    @objc optional func ingredientAdded(ingredient: Ingredient)
}

class IngredientTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var addButton: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminder: UILabel!
    var ingredientDelegate: IngredientTableViewCellDelegate!
    var ingredient: Ingredient! {
        didSet {
            ingredient.getImage(success: { (image) in
                if image != nil {
                    self.ingredientImage.image = image
                } else if self.ingredient.image != nil {
                    self.ingredientImage.setImageWith(self.ingredient.getImageUrl()!)
                }
            }) { (error) in
                print("Error: \(error.localizedDescription)")
            }
            ingredientName.text = ingredient.name
            if ingredient.quantity != nil {
                quantityLabel.text = ingredient.quantity?.description
                quantity.isHidden = false
            } else {
                quantity.isHidden = false
                quantityLabel.text = "0"
            }
            if ingredient.reminderDays != nil {
                reminderLabel.text = (ingredient.reminderDays?.description)! + " DAYS"
                reminder.isHidden = false
            } else {
                reminderLabel.text = "0"
                reminder.isHidden = false
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let addIngredientRecognizer = UITapGestureRecognizer(target: self, action: #selector(onAddIngredient(tapGestureRecognizer:)))
        addButton.isUserInteractionEnabled = true
        addButton.addGestureRecognizer(addIngredientRecognizer)
        cardView.addShadow()
        quantity.addTextSpacing(spacing: 1.5)
        reminder.addTextSpacing(spacing: 1.5)
    }
    
    @objc func onAddIngredient(tapGestureRecognizer: UITapGestureRecognizer) {
        ingredientDelegate.ingredientAdded!(ingredient: ingredient)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
    }
}
