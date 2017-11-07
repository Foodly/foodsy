//
//  IngredientSearchViewController.swift
//  foodsy
//
//  Created by drishi on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

@objc protocol IngredientSearchViewControllerDelegate {
    @objc optional func ingredientAdded(ingredient: Ingredient)
}

class IngredientSearchViewController: UIViewController {
    @IBOutlet weak var ingredientsTable: UITableView!
    var searchBar: UISearchBar!
    var ingredients: [Ingredient]!
    var selectedIngredient: Ingredient!
    weak var delegate: IngredientSearchViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        navigationItem.titleView = self.searchBar
        let cellNib = UINib(nibName: "IngredientTableViewCell", bundle: nil)
        let customNib = UINib(nibName: "AddCustomTableViewCell", bundle: nil)
        ingredientsTable.register(cellNib, forCellReuseIdentifier: "IngredientCellSearch")
        ingredientsTable.register(customNib, forCellReuseIdentifier: "AddCustomCell")
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        ingredientsTable.rowHeight = UITableViewAutomaticDimension
        ingredientsTable.rowHeight = 110
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomIngredient" {
            let addVc = segue.destination as! AddCustomViewController
            addVc.ingredient = self.selectedIngredient
            addVc.delegate = self
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension IngredientSearchViewController: IngredientTableViewCellDelegate {
    func ingredientAdded(ingredient: Ingredient) {
        self.selectedIngredient = ingredient
        performSegue(withIdentifier: "addCustomIngredient", sender: self)
    }
}

extension IngredientSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if ingredients != nil {
                return ingredients.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedIngredient = nil
            performSegue(withIdentifier: "addCustomIngredient", sender: self)
        } else if indexPath.section == 1 {
            self.selectedIngredient = self.ingredients[indexPath.row]
            performSegue(withIdentifier: "addCustomIngredient", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            self.selectedIngredient = nil
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCustomCell") as! AddCustomTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCellSearch") as! IngredientTableViewCell
            cell.ingredientDelegate = self
            cell.ingredient = ingredients[indexPath.row]
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

extension IngredientSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        IngredientClient.SharedInstance.fetchIngredients(name: escapedString!, success: { (ingredients) in
            self.ingredients = ingredients
            self.ingredientsTable.reloadData()
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension IngredientSearchViewController: AddCustomViewControllerDelegate {
    func onAddIngredient(ingredient: Ingredient) {
        self.navigationController?.popToViewController(self, animated: true)
        self.delegate.ingredientAdded!(ingredient: ingredient)
        dismiss(animated: true, completion: nil)
    }
}
