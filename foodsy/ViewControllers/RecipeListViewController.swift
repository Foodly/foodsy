//
//  RecipeListViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import MBProgressHUD

class RecipeListViewController: UIViewController {

    @IBOutlet weak var tableView: RecipeTableView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    var selectedRecipe: Recipe?
    var searchParams = [String:[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(addTapped))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Ingredient.fetchIngredientsForUser(name: (User.currentUser?.screenname)!, type: "ingredient") { (ingredients) in
            if let ingredients = ingredients {
                var ingredientList = [String]()
                
                for ingredient in ingredients {
                    ingredientList.append(ingredient.name.lowercased())
                }
                Filters.sharedInstance.setIngredients(ingredientsList: ingredientList)
            }
            self.searchRecipes()
        }
        
    }
    
    func getParams() -> NSDictionary {
        var params = [String:[String]]()
        var dietChoice: String!
        let dietState = Filters.sharedInstance.getDietState()
        if dietState > 0 {
            dietChoice = DIET_FILTER_OPTIONS[dietState].lowercased()
            params["diet"] = [dietChoice]
        }

        var intoleranceChoices = [String]()
        let intolerancesStates = Filters.sharedInstance.getIntolerancesStates()
        for (idx,isSelected) in intolerancesStates{
            if isSelected {
                intoleranceChoices.append(INTOLERANCES_FILTER_OPTIONS[idx].lowercased())
            }
        }

        if intoleranceChoices.count > 0 {
            params["intolerances"] = intoleranceChoices
        }

        var typeChoice: String!
        let typeState = Filters.sharedInstance.getTypeSelectState()

        if typeState > 0 {
            typeChoice = TYPE_FILTER_OPTIONS[typeState].lowercased()
            params["type"] = [typeChoice]
        }

        var cuisineChoices = [String]()
        let cuisineStates = Filters.sharedInstance.getCuisineStates()
        for (idx,isSelected) in cuisineStates{
            if isSelected {
                cuisineChoices.append(CUISINE_FILTER_OPTIONS[idx].lowercased())
            }
        }

        if cuisineChoices.count > 0 {
            params["cuisine"] = cuisineChoices
        }
        
        let ingredientsList = Filters.sharedInstance.getIngredients()
        
        if ingredientsList.count > 0 {
            params["includeIngredients"] = ingredientsList
        }
        
        return params as NSDictionary
    }
    
    
    func searchRecipes() {
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        let params = self.getParams()
        RecipeClient.SharedInstance.fetchRecipes(params: params, success: { (recipes) in
            self.tableView.recipes = recipes
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.tableView, animated: false)
            Recipe.fetchFavoriteRecipesForUser(name: (User.currentUser?.screenname)!) { (recipes) in
                if let recipes = recipes {
                    for recipe in recipes {
                        let recipeID = recipe.id as! Int
                        self.tableView.recipeFavorites[recipeID] = true
                        self.tableView.reloadData()
                    }
                }
            }
        }) { (error) in
            print(error)
            //MBProgressHUD.hide(for: self.tableView, animated: true)
        }
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        let filterStoryboard = UIStoryboard(name: "Filters", bundle: nil)
        let filtersNavigationController = filterStoryboard.instantiateViewController(withIdentifier: "FiltersNavigationController") as! UINavigationController
        let filtersViewController = filtersNavigationController.childViewControllers[0] as! FiltersViewController
        self.present(filtersNavigationController, animated: true, completion: nil)
    }
    
    func favoriteTapped(recipe: Recipe) {
        let recipeID = recipe.id as! Int
        if let recipeFavorite = tableView.recipeFavorites[recipeID]{
           tableView.recipeFavorites[recipeID] = !recipeFavorite
        } else {
            tableView.recipeFavorites[recipeID] = true
        }
        
        if tableView.recipeFavorites[recipeID]! {
            recipe.favoriteForUser()
        } else {
            recipe.unfavoriteForUser()
        }
    }
    
    func setRecipeBtnImageState(recipeCell: RecipeCell, recipeID: Int) {
        if tableView.recipeFavorites[recipeID] != nil && tableView.recipeFavorites[recipeID]! {
            let image = UIImage(named: "heart-filled") as UIImage!
            recipeCell.favoriteBtn.setBackgroundImage(image, for: UIControlState.normal)
        } else {
            let image = UIImage(named: "heart") as UIImage!
            recipeCell.favoriteBtn.setBackgroundImage(image, for: UIControlState.normal)
        }
        
    }
}

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
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
        let recipeID = recipe?.id as! Int
        cell.recipe = recipe
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        
        setRecipeBtnImageState(recipeCell: cell, recipeID: recipeID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableView = tableView as! RecipeTableView
        selectedRecipe = tableView.recipes?[indexPath.row]
        let storyboard = UIStoryboard(name: "Recipe", bundle: nil)
        let recipeDetailsViewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        recipeDetailsViewController.recipe = selectedRecipe
        recipeDetailsViewController.navigationItem.leftBarButtonItem?.tintColor = .white
        let navController = UINavigationController(rootViewController: recipeDetailsViewController)
        recipeDetailsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< RECIPES", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack(_:)))
        navController.navigationBar.isTranslucent = false
        
        //var buttons = [UIBarButtonItem]()
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.sizeToFit()
        button.addTarget(recipeDetailsViewController, action: #selector(recipeDetailsViewController.onAddNewPhoto(_:)), for: .touchUpInside)
        navController.childViewControllers[0].navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        /*let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(named: "share-arrow"), for: .normal)
        shareButton.sizeToFit()
        shareButton.addTarget(recipeDetailsViewController, action: #selector(recipeDetailsViewController.onShareRecipe(_:)), for: .touchUpInside)
        buttons.append(UIBarButtonItem(customView: shareButton))
        navController.childViewControllers[0].navigationItem.rightBarButtonItems = buttons*/

        self.show(navController, sender: self)
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension RecipeListViewController: FavoriteCellDelegate {
    func favoriteCell(favoriteRecipeCell: RecipeCell) {
        let indexPath = tableView.indexPath(for: favoriteRecipeCell)!
        let recipe = tableView.recipes![indexPath.row]
        let recipeID = recipe.id as! Int
        self.favoriteTapped(recipe: recipe)
        self.setRecipeBtnImageState(recipeCell: favoriteRecipeCell, recipeID: recipeID)
    }
}
