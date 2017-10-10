//
//  ProfileView.swift
//  foodsy
//
//  Created by hsherchan on 10/10/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    
    var profile: Profile! {
        didSet {
            nameLabel.text = profile.name
            profileImageView.image = UIImage(named: "user")
        }
    }
    
    override func awakeFromNib() {
        profileImageView.image = UIImage(named: "user")
        profileImageView.layer.cornerRadius = 50;
        profileImageView.clipsToBounds = true;
        
        redBtn.layer.cornerRadius = 30;
        redBtn.tag = 0
        
        
        yellowBtn.layer.cornerRadius = 30;
        yellowBtn.tag = 1
        
        greenBtn.tag = 2
        greenBtn.layer.cornerRadius = 30;
        
        yellowBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        redBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        yellowBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        greenBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
    }
    
    @objc func pressButton(_ button: UIButton) {
        if button.tag == 0 {
            redBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            yellowBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
            greenBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        } else if button.tag == 1 {
            redBtn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            yellowBtn.transform = CGAffineTransform(scaleX: 1.5, y:1.5)
            greenBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        } else if button.tag == 2 {
            redBtn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            yellowBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
            greenBtn.transform = CGAffineTransform(scaleX: 1.5, y:1.5)
        }
    }
}
