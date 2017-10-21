//
//  AddCustomViewController.swift
//  foodsy
//
//  Created by drishi on 10/20/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class AddCustomViewController: UIViewController {

    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var remindIn: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onAddPhoto(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
