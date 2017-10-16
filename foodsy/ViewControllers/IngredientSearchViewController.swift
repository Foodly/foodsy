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
    var delegate: IngredientSearchViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        navigationItem.titleView = self.searchBar
        let cellNib = UINib(nibName: "IngredientTableViewCell", bundle: nil)
        ingredientsTable.register(cellNib, forCellReuseIdentifier: "IngredientCellSearch")
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        ingredientsTable.rowHeight = UITableViewAutomaticDimension
        ingredientsTable.estimatedRowHeight = 300
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension IngredientSearchViewController: IngredientTableViewCellDelegate {
    func ingredientAdded(ingredient: Ingredient) {
        self.delegate.ingredientAdded!(ingredient: ingredient)
        dismiss(animated: true, completion: nil)
    }
}

extension IngredientSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ingredients != nil {
            return ingredients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCellSearch") as! IngredientTableViewCell
        cell.delegate = self
        cell.ingredient = ingredients[indexPath.row]
        return cell
    }
    
}

extension IngredientSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        IngredientClient.SharedInstance.fetchIngredients(name: searchText, success: { (ingredients) in
            self.ingredients = ingredients
            self.ingredientsTable.reloadData()
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }
}
