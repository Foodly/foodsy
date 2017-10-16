//
//  Constants.swift
//  foodsy
//
//  Created by hsherchan on 10/10/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import Foundation

enum FoodPreferences : Int {
    case RED = 1;
    case YELLOW = 2;
    case GREEN = 3;
}

enum FoodFiltersTitle : String {
    case DIET = "Diet";
    case INTOLERANCES = "Intolerances"
    case TYPE = "Type";
    case CUISINE = "Cuisine";
}

let CUISINE: [String] = ["African", "American",  "British", "Cajun", "Caribbean", "Chinese", "Eastern European", "French", "Greek", "German","Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai",  "Vietnamese"]
let DIET: [String] = ["Any", "Lacto Vegetarian", "Ovo", "Paleo", "Pescetarian", "Primal",  "Vegetarian", "Vegan"]
let INTOLERANCES: [String] = ["Dairy", "Egg", "Gluten", "Peanut", "Sesame", "Seafood", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
let TYPE: [String] = ["Any", "Main Course", "Side Dish", "Dessert", "Appetizer", "Salad", "Bread", "Breakfast", "Soup", "Beverage", "Sauce", "Drink"]
