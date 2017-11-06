//
//  RecipeTableView.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeTableView: UITableView {

    var recipes: [Recipe]?
    var recipeFavorites = [Int: Bool]()
    override func awakeFromNib() {
        self.estimatedRowHeight = 134
        self.rowHeight = UITableViewAutomaticDimension
        
        let recipeCellNib = UINib(nibName: "RecipeCell", bundle: nil)
        self.register(recipeCellNib, forCellReuseIdentifier: "RecipeCell")
    }
}
