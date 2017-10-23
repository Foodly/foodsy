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

class AddCustomViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var remindIn: UITextField!
    @IBOutlet weak var addIngredientItem: UIBarButtonItem!
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
            ingredientImage.setImageWith(ingredient.getImageUrl())
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func onAddPhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddIngredient(_ sender: Any) {
        if ingredient == nil {
            ingredient = Ingredient()
        }
        ingredient?.name = name.text?.capitalized
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

extension AddCustomViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
}
