//
//  RecipeDetailsViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    var recipeID:Int?
    var recipe: Recipe?
    var ingredients: [String]?
    var instructions: [String]?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var curtainView: UIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipe?.image != nil {
            self.recipeImageView.setImageWith(URL(string:(recipe?.image)!)!)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        containerView.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.90, alpha:1.0)
        self.curtainView.alpha = 1.0
        let recipeCellNib = UINib(nibName: "RecipeMainIngredientsCardCell", bundle: nil)
        self.collectionView.register(recipeCellNib, forCellWithReuseIdentifier: "RecipeMainIngredientsCardCell")
        
        let recipeInstructionCellNib = UINib(nibName: "RecipeInstructionCardCell", bundle: nil)
        self.collectionView.register(recipeInstructionCellNib, forCellWithReuseIdentifier: "RecipeInstructionCardCell")

        print(recipe?.analyzedInstructions)
        instructions = recipe?.getInstructions()
        recipeID = recipe?.id as? Int
        
        
        RecipeClient.SharedInstance.fetchRecipe(recipeId: recipeID!, success: { (recipe: Recipe) in
            self.ingredients = recipe.getIngredients()
            self.collectionView.reloadData()
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.curtainView.alpha = 0.0
            })
        }) { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RecipeDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return instructions!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeMainIngredientsCardCell", for: indexPath) as! RecipeMainIngredientsCardCell
            cell.recipe = recipe
            if let ingredients = ingredients {
                cell.ingredients = ingredients
            }
            return cell
        } else if indexPath.section > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeInstructionCardCell", for: indexPath) as! RecipeInstructionCardCell
            cell.titleLabel.text = recipe?.title
            cell.stepLabel.text = "Step \(indexPath.section)"
            cell.instructionLabel.text = instructions?[indexPath.section-1]
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height);
    }
    
    
}
