//
//  ProfileSetupView.swift
//  foodsy
//
//  Created by hsherchan on 10/13/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class ProfileSetupView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var redBtn: UIButton!
    
    @IBOutlet weak var greenBtn: UIButton!
    
    @IBOutlet weak var blueBtn: UIButton!
    
    
    var profile: Profile! {
        didSet {
            profileNameLabel.text = profile.name
            profileImageView.image = UIImage(named: "user")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        profileSetupInit()
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        profileSetupInit()
    }
    
    private func profileSetupInit() {
        Bundle.main.loadNibNamed("ProfileSetupView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func awakeFromNib() {
        profileImageView.image = UIImage(named: "user")
        profileImageView.layer.cornerRadius = 50;
        profileImageView.clipsToBounds = true;
        
        redBtn.layer.cornerRadius = 30;
        redBtn.tag = 0
        
        greenBtn.layer.cornerRadius = 30;
        greenBtn.tag = 1
        
        blueBtn.tag = 2
        blueBtn.layer.cornerRadius = 30;
        
        blueBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        redBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        greenBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        blueBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
    }
    
    @objc func pressButton(_ button: UIButton) {
        if button.tag == 0 {
            redBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            blueBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
            greenBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        } else if button.tag == 1 {
            redBtn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            blueBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
            greenBtn.transform = CGAffineTransform(scaleX: 1.5, y:1.5)
        } else if button.tag == 2 {
            redBtn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            blueBtn.transform = CGAffineTransform(scaleX: 1.5, y:1.5)
            greenBtn.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        }
    }

}
