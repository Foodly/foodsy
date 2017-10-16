//
//  FiltersSelectCell.swift
//  foodsy
//
//  Created by hsherchan on 10/14/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

@objc protocol SelectCellDelegate {
    @objc optional func selectCell(selectCell: FiltersSelectCell, isSelected value:Bool)
}

class FiltersSelectCell: UITableViewCell {

    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    weak var delegate: SelectCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectBtn.layer.cornerRadius = 15
        selectBtn.clipsToBounds = true
        
        selectBtn.addTarget(self, action: #selector(FiltersSelectCell.newOptionSelected), for: UIControlEvents.touchDown)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func newOptionSelected() {
        delegate?.selectCell?(selectCell: self, isSelected: true)
    }
    
}
