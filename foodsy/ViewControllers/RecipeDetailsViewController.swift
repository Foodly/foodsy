//
//  RecipeDetailsViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    var strings:[String] = []
    @IBOutlet weak var bulletLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nonBullet = "Hey this is a paragraph that shouldn't be formatted at all! It should not be indented in the slightest and hopefully be about three to four lines long! \n\n"
        
        let bullet1 = "This is a small string"
        let bullet2 = "This is more of medium string with a few more words etc."
        let bullet3 = "Well this is certainly a longer string, with many more words than either of the previuos two strings"
        
        strings = [bullet1, bullet2, bullet3]
        
        let attributesDictionary = [NSAttributedStringKey.font : bulletLabel.font]
        let fullAttributedString = NSMutableAttributedString(string: nonBullet, attributes: attributesDictionary)
        
        for string: String in strings
        {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green,
                                          range: NSRange(
                                            location:0, // Find the location of the bullet and replace it
                                            length: 1))
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        
        bulletLabel.attributedText = fullAttributedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: [:])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }

}
