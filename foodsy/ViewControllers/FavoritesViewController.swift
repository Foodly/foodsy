//
//  FavoritesViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/20/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: RecipeTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Recipe.fetchFavoriteRecipesForUser(name: (User.currentUser?.screenname)!) { (recipes) in
            self.tableView.recipes = recipes;
            self.tableView.reloadData()
        }
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableView = tableView as! RecipeTableView
        
        if let recipes = tableView.recipes {
            return recipes.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableView = tableView as! RecipeTableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = tableView.recipes?[indexPath.row]
        cell.recipe = recipe
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        let image = UIImage(named: "heart-filled") as UIImage!
        cell.favoriteBtn.setBackgroundImage(image, for: UIControlState.normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableView = tableView as! RecipeTableView
        let selectedRecipe = tableView.recipes?[indexPath.row]
        let storyboard = UIStoryboard(name: "Recipe", bundle: nil)
        let recipeDetailsViewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        recipeDetailsViewController.recipe = selectedRecipe
        recipeDetailsViewController.navigationItem.leftBarButtonItem?.tintColor = .white
        let navController = UINavigationController(rootViewController: recipeDetailsViewController)
        navController.childViewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Recipes", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack(_:)))
        self.show(navController, sender: self)
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension FavoritesViewController: FavoriteCellDelegate {
    func favoriteCell(favoriteRecipeCell: RecipeCell) {
        let indexPath = tableView.indexPath(for: favoriteRecipeCell)!
        let recipe = tableView.recipes![indexPath.row]
        recipe.unfavoriteForUser()
        self.tableView.recipes?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
    }
}
