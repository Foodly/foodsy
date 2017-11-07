//
//  MapItem.swift
//  foodsy
//
//  Created by drishi on 10/29/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import MapKit

class MapItem: MKAnnotationView {
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    var business: Business! {
        didSet {
            if let imageUrl = business.imageURL {
                businessImage.setImageWith(imageUrl)
            }
            businessName.text = business.name
            distanceLabel.text = business.distance
            addressLabel.text = business.address
            ratingImage.setImageWith(business.ratingImageURL!)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
}
