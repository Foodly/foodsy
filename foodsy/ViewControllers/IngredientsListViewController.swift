//
//  IngredientsListViewController.swift
//  foodsy
//
//  Created by drishi on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class IngredientsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var ingredients: [Ingredient]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "IngredientTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "IngredientCell")
        self.title = "Ingredients"
        self.ingredients = [Ingredient]()
        Ingredient.fetchIngredientsForUser(name: (User.currentUser?.screenname)!) { (ingredients) in
            self.ingredients = ingredients
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchIngredients" {
            let nav = segue.destination as! UINavigationController
            let searchVc = nav.topViewController as! IngredientSearchViewController
            searchVc.delegate = self
        }
    }

}

extension IngredientsListViewController: IngredientSearchViewControllerDelegate {
    func ingredientAdded(ingredient: Ingredient) {
        ingredient.saveForUser()
        self.ingredients.append(ingredient)
        self.tableView.reloadData()
    }
}

extension IngredientsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ingredients != nil {
            return ingredients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientTableViewCell
        cell.addButton.isHidden = true
        cell.ingredient = ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
