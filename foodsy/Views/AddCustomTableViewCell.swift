//
//  AddCustomTableViewCell.swift
//  foodsy
//
//  Created by drishi on 10/20/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class AddCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.addShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
