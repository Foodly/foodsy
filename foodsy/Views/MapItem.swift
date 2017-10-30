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

    @IBOutlet weak var placeLabel: UILabel!
    var business: Business! {
        didSet {
            placeLabel.text = business.name
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func onScheduleGeoReminder(_ sender: UIButton) {
    }
}
