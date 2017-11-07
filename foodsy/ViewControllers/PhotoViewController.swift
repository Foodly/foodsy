//
//  PhotoViewController.swift
//  foodsy
//
//  Created by hsherchan on 11/7/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            recipeImageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        let textToShare = "Made it on Crave"
        
        let objectsToShare = [textToShare, self.image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
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
