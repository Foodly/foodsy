//
//  AddCustomViewController.swift
//  foodsy
//
//  Created by drishi on 10/20/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

protocol AddCustomViewControllerDelegate {
    func onAddIngredient(ingredient: Ingredient)
}

protocol EditCustomViewControllerDelegate {
    func onEditIngredient(ingredient: Ingredient)
}

class AddCustomViewController: UIViewController {

    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var remindIn: UITextField!
    @IBOutlet weak var addIngredientItem: UIBarButtonItem!
    @IBOutlet var imageTapRecognizer: UITapGestureRecognizer!
    var delegate: AddCustomViewControllerDelegate!
    var editDelegate: EditCustomViewControllerDelegate!
    var mode = "create"
    var ingredient: Ingredient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ingredient = self.ingredient {
            if self.mode == "create" {
                addIngredientItem.title = "Add"
            } else if self.mode == "edit" {
                addIngredientItem.title = "Save"
            }
            name.text = ingredient.name
            if let quant = ingredient.quantity {
                quantity.text = quant.description
            }
            if let remind = ingredient.reminderDays {
                remindIn.text = remind.description
            }
            addPhotoButton.isHidden = true
            ingredientImage.setImageWith(ingredient.getImageUrl()!)
            ingredientImage.isUserInteractionEnabled = true
            self.addIngredientItem.isEnabled = true
        } else {
            self.addIngredientItem.isEnabled = false
            ingredientImage.isUserInteractionEnabled = false
        }
        name.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField.text?.isEmpty == false {
            self.addIngredientItem.isEnabled = false
        } else {
            self.addIngredientItem.isEnabled = true
        }
    }
    
    @IBAction func onAddPhoto(_ sender: Any) {
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
    
    @IBAction func onTapIngredientImage(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showPhotoDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoDetail" {
            let navVc = segue.destination as! UINavigationController
            let vc = navVc.topViewController as! PhotoDetailViewController
            vc.delegate = self
            vc.ingredient = self.ingredient
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddIngredient(_ sender: Any) {
        if ingredient == nil {
            ingredient = Ingredient()
        }
        if !(name.text?.isEmpty)! {
            ingredient?.name = name.text?.capitalized
        }
        if !(quantity.text?.isEmpty)! {
            ingredient?.quantity = NSNumber(value: Int(quantity.text!)!)
        }
        if !(remindIn.text?.isEmpty)! {
            ingredient?.reminderDays = NSNumber(value: Int(remindIn.text!)!)
        }
        if self.mode == "create" {
            self.delegate.onAddIngredient(ingredient: ingredient!)
        } else if self.mode == "edit" {
            self.editDelegate.onEditIngredient(ingredient: ingredient!)
        }
    }
}

extension AddCustomViewController: PhotoDetailViewControllerDelegate {
    func onAddedNewPhoto(ingredient: Ingredient, changed: Bool, image: UIImage) {
        if changed == true {
            self.ingredientImage.image = image
        }
    }
}

extension AddCustomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.ingredientImage.image = editedImage
        addPhotoButton.isHidden = true
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
}
