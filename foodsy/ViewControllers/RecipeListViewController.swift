//
//  RecipeListViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {

    @IBOutlet weak var tableView: RecipeTableView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    var selectedRecipe: Recipe?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        searchRecipes(params: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(addTapped))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchRecipes(params: NSDictionary?) {
        RecipeClient.SharedInstance.fetchRecipes(params: params, success: { (recipes) in
            self.tableView.recipes = recipes
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            let detailsViewController = segue.destination as! RecipeDetailsViewController
            detailsViewController.recipe = selectedRecipe
        }
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        let filterStoryboard = UIStoryboard(name: "Filters", bundle: nil)
        let filtersNavigationController = filterStoryboard.instantiateViewController(withIdentifier: "FiltersNavigationController") as! UINavigationController
        let filtersViewController = filtersNavigationController.childViewControllers[0] as! FiltersViewController
        filtersViewController.delegate = self
        self.present(filtersNavigationController, animated: true, completion: nil)
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
        cell.recipe = tableView.recipes?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableView = tableView as! RecipeTableView
        selectedRecipe = tableView.recipes?[indexPath.row]
        
        self.performSegue(withIdentifier: "showRecipeDetails", sender: nil)
        
    }
}

extension RecipeListViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, dietChoice: String, intoleranceChoices: [String], typeChoice: String, cuisineChoices: [String]) {
        var params = [String:[String]]()
        
        if dietChoice.count > 0 {
           params["diet"] = [dietChoice]
        }
        
        if intoleranceChoices.count > 0 {
            params["intolerances"] = intoleranceChoices
        }
        
        if typeChoice.count > 0 {
            params["type"] = [typeChoice]
        }
        
        if cuisineChoices.count > 0 {
            params["cuisine"] = cuisineChoices
        }
        
        searchRecipes(params:params as NSDictionary)
    }
}
