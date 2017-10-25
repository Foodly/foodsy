//
//  PhotoDetailViewController.swift
//  foodsy
//
//  Created by drishi on 10/24/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

protocol PhotoDetailViewControllerDelegate {
    func onAddedNewPhoto(ingredient: Ingredient, changed: Bool, image: UIImage)
}

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var delegate: PhotoDetailViewControllerDelegate!
    var changedImage = false
    var ingredient: Ingredient!
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredient.getImage(success: { (image) in
            if image != nil {
                self.photoImageView.image = image
            } else if self.ingredient.image != nil {
                self.photoImageView.setImageWith(self.ingredient.getImageUrl()!)
            }
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        self.delegate.onAddedNewPhoto(ingredient: self.ingredient, changed: changedImage, image: photoImageView.image!)
        self.ingredient = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddNewPhoto(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PhotoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.photoImageView.image = editedImage
        self.ingredient.setImage(image: editedImage)
        changedImage = true
    }
}
