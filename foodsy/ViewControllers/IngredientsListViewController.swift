//
//  IngredientsListViewController.swift
//  foodsy
//
//  Created by drishi on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import MapKit
import SwipeCellKit

class IngredientsListViewController: UIViewController {

    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var locationManager: CLLocationManager!
    var ingredients: [Ingredient]!
    var selectedIngredient: Ingredient!
    var isMapViewShowing = false
    var searchBar: UISearchBar!
    var lastLocation : CLLocationCoordinate2D!
    var vcIdentifier: String!
    var selectedIndex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        self.ingredients = [Ingredient]()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchIngredientsAndUpdateTable();
        setTitleBasedOnIdentifier()
    }
    
    func setTitleBasedOnIdentifier() {
        if self.vcIdentifier == "ingredient" {
            self.title = "Kitchen"
        } else {
            self.title = "Cart"
        }
    }
    
    func fetchIngredientsAndUpdateTable() {
        Ingredient.fetchIngredientsForUser(name: (User.currentUser?.screenname)!, type: self.vcIdentifier) { (ingredients) in
            self.ingredients = ingredients
            self.tableView.reloadData()
        }
    }
    
    func setUpViews() {
        mapView.isHidden = true
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "IngredientTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "IngredientCell")
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        self.searchBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMapViewToggle(_ sender: UIBarButtonItem) {
        if isMapViewShowing {
            mapButton.title = "Map"
            mapView.isHidden = true
            isMapViewShowing = false
            tableView.isHidden = false
            self.searchBar.isHidden = true
            navigationItem.titleView = nil
            setTitleBasedOnIdentifier()
        } else {
            mapButton.title = "List"
            navigationItem.titleView = self.searchBar
            mapView.isHidden = false
            isMapViewShowing = true
            tableView.isHidden = true
            self.searchBar.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchIngredients" {
            let nav = segue.destination as! UINavigationController
            let searchVc = nav.topViewController as! IngredientSearchViewController
            searchVc.delegate = self
        } else if segue.identifier == "showIngredientDetails" {
            let detailsVc = segue.destination as! AddCustomViewController
            detailsVc.ingredient = self.selectedIngredient
            detailsVc.mode = "edit"
            detailsVc.editDelegate = self
            detailsVc.index = self.selectedIndex
        }
    }
}

extension IngredientsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: lastLocation, span: span)
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, error in
            let placemarks = NSMutableArray()
            if let response = response {
                for item in response.mapItems {
                    placemarks.add(item.placemark)
                }
                self.mapView.showAnnotations(placemarks as! [MKAnnotation], animated: true)
            }
        })
    }
}

extension IngredientsListViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        lastLocation = userLocation.coordinate
    }
}

extension IngredientsListViewController: IngredientSearchViewControllerDelegate {
    func ingredientAdded(ingredient: Ingredient) {
        ingredient.type = self.vcIdentifier
        ingredient.saveForUser {
            self.ingredients.append(ingredient)
            self.tableView.reloadData()
        }
    }
}

extension IngredientsListViewController: EditCustomViewControllerDelegate {
    func onEditIngredient(ingredient: Ingredient, index: Int) {
        self.navigationController?.popToViewController(self, animated: true)
        ingredient.saveInBackground { (result, error) in
            self.ingredients[index] = ingredient
            self.tableView.reloadData()
        }
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
        cell.delegate = self
        cell.ingredient = ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIngredient = ingredients[indexPath.row]
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "showIngredientDetails", sender: self)
    }
    
}

extension IngredientsListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let ingredient = self.ingredients[indexPath.row]
        if orientation == .right {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete", handler: { action, indexPath in
                // handle action by updating model with deletion
                ingredient.deleteInBackground()
                self.ingredients.remove(at: indexPath.row)
            })
            return [deleteAction]
        } else if orientation == .left {
            let completedAction = SwipeAction(style: .default, title: "Done", handler: { (action, indexPath) in
                if self.vcIdentifier == "shopping" {
                    ingredient.type = "ingredient"
                    ingredient.saveInBackground()
                } else {
                    ingredient.type = "shopping"
                    ingredient.saveInBackground()
                }
                self.ingredients.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
            completedAction.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 29/255, alpha: 1.0)
            return [completedAction]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        if orientation == .right {
            options.expansionStyle = .destructive
        } else if orientation == .left {
            options.expansionStyle = .selection
            options.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 29/255, alpha: 1.0)
        }
        options.transitionStyle = .drag
        return options
    }
}
