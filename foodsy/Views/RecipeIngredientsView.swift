//
//  RecipeIngredientsView.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

final class RecipeIngredientsView: UIView {
    
    @IBOutlet weak var mealColorView: UIView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    var recipe: Recipe! {
        didSet {
            titleLabel.text = recipe.title
            servingsLabel.text = "\(recipe.servings!) servings"
            prepTimeLabel.text = "\(recipe.readyInMinutes!) min"
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RecipeIngredientsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func displayBulletList(list: [String], title: String, attributesDictionary: [NSAttributedStringKey : Any]) {
        let fullAttributedString = NSMutableAttributedString()
        for value in list {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(value)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 255/255, green: 131/255, blue: 68/255, alpha: 1.0)  ,
                                          range: NSRange(
                                            location:0, // Find the location of the bullet and replace it
                                            length: 1))
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 18),
                                          range: NSRange(
                                            location:0, // Find the location of the bullet and replace it
                                            length: 1))
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 4,
                                          range: NSRange(
                                            location:0, // Find the location of the bullet and replace it
                                            length: 1))
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            fullAttributedString.append(attributedString)
            
        }
        ingredientsLabel.attributedText = fullAttributedString
    }
    
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 12, options: [:])]
        paragraphStyle.defaultTabInterval = 12
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 12
        paragraphStyle.lineSpacing = 5
        return paragraphStyle
    }

    

}
