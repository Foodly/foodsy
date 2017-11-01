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

let DIET_SECTION_TITLE:String = "DIET";
let INTOLERANCES_SECTION_TITLE:String = "ALLERGIES"
let TYPE_SECTION_TITLE:String = "MEAL TYPE";
let CUISINE_SECTION_TITLE:String = "CUISINE";

let CUISINE_FILTER_OPTIONS: [String] = ["African", "American",  "British", "Cajun", "Caribbean", "Chinese", "Eastern European", "French", "Greek", "German","Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai",  "Vietnamese"]
let DIET_FILTER_OPTIONS: [String] = ["Any", "Lacto Vegetarian", "Ovo", "Paleo", "Pescetarian", "Primal",  "Vegetarian", "Vegan"]
let INTOLERANCES_FILTER_OPTIONS: [String] = ["Dairy", "Egg", "Gluten", "Peanut", "Sesame", "Seafood", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
let TYPE_FILTER_OPTIONS: [String] = ["Any", "Main Course", "Side Dish", "Dessert", "Appetizer", "Salad", "Bread", "Breakfast", "Soup", "Beverage", "Sauce", "Drink"]
