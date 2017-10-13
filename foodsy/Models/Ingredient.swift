//
//  Ingredient.swift
//  foodsy
//
//  Created by hsherchan on 10/13/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class Ingredient: NSObject {
    
    // Based on this
    // https://world.openfoodfacts.org/api/v0/product/737628064502.json
    var brandName: String?
    var productName: String?
    var genericName: String?
    var nutritionalGrade: String?
    var thumbnailUrl: URL?
    
    init(data: NSDictionary) {
        self.brandName = data["brands"] as? String
        self.productName = data["product_name"] as? String
        self.genericName = data["generic_name"] as? String
        let product = data["product"] as? NSDictionary
        self.nutritionalGrade = product!["nutrition_grade_fr"] as? String
        
        let selectedImages = data["selected_images"] as? NSDictionary
        let front = selectedImages!["front"] as? NSDictionary
        let thumbnailUrlString = front!["thumb"] as? String
        if let thumbnailUrlString = thumbnailUrlString {
            self.thumbnailUrl = URL(string: thumbnailUrlString)
        }
    }
}
