//
//  IngredientsListViewController.swift
//  foodsy
//
//  Created by drishi on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import MapKit

class IngredientsListViewController: UIViewController {

    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var locationManager: CLLocationManager!
    var ingredients: [Ingredient]!
    var isMapViewShowing = false
    var searchBar: UISearchBar!
    var lastLocation : CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        self.ingredients = [Ingredient]()
        Ingredient.fetchIngredientsForUser(name: (User.currentUser?.screenname)!) { (ingredients) in
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
        self.title = "Ingredients"
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        self.searchBar.isHidden = true
        navigationItem.titleView = self.searchBar
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
        } else {
            mapButton.title = "List"
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
