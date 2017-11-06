//
//  Filters.swift
//  foodsy
//
//  Created by hsherchan on 10/29/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class Filters: NSObject {
    static let sharedInstance = Filters()
    
    var dietSelectState = 0
    var typeSelectState = 0
    var intolerancesSwitchStates = [Int: Bool]()
    var cuisineSwitchStates = [Int: Bool]()
    var ingredients = [String]()
    
    func areAllDifferent(dietState: Int, typeState: Int, intolerancesStates: [Int: Bool], cuisineStates: [Int: Bool]) -> Bool{
        
        if isDietStateDifferent(dietState: dietState) {
            return true
        }
        
        if isTypeStateDifferent(typeState: typeState) {
            return true
        }
        
        if areIntolerancesDifferent(intolerancesStates: intolerancesStates) {
            return true
        }
        
        if areCuisinesDifferent(cuisineStates: cuisineStates) {
            return true
        }
        
        return false
    }
    
    func isDietStateDifferent(dietState: Int) -> Bool {
        if (dietState != self.dietSelectState) {
            return true
        }
        return false
    }
    
    func isTypeStateDifferent(typeState: Int) -> Bool {
        if (typeState != self.typeSelectState) {
            return true
        }
        return false
    }
    
    func areIntolerancesDifferent(intolerancesStates: [Int: Bool]) -> Bool {
        for intolerance in intolerancesStates {
            if self.intolerancesSwitchStates[intolerance.key] != nil {
                if self.intolerancesSwitchStates[intolerance.key] != intolerance.value {
                    return true
                }
            } else {
                if intolerance.value == true {
                    return true
                }
                
            }
        }
        
        return false
    }
    
    func areCuisinesDifferent(cuisineStates: [Int: Bool]) -> Bool {
        for cuisine in cuisineStates {
            if self.cuisineSwitchStates[cuisine.key] != nil {
                if self.cuisineSwitchStates[cuisine.key] != cuisine.value {
                    return true
                }
            } else {
                if cuisine.value == true {
                   return true
                }
                
            }
        }
        
        return false
    }
    
    func getDietState() -> Int {
        return self.dietSelectState
    }
    
    func getTypeSelectState() -> Int {
        return self.typeSelectState
    }
    
    func getIntolerancesStates() -> [Int: Bool] {
        return self.intolerancesSwitchStates
    }
    
    func getCuisineStates() -> [Int: Bool] {
        return self.cuisineSwitchStates
    }
    
    func getIngredients() -> [String] {
        return self.ingredients
    }
    
    func setFilters(dietState: Int, typeState: Int, intolerancesStates: [Int: Bool], cuisineStates: [Int: Bool]) {
        self.dietSelectState = dietState
        self.typeSelectState = typeState
        self.intolerancesSwitchStates = intolerancesStates
        self.cuisineSwitchStates = cuisineStates
    }
    
    func setIngredients(ingredientsList:[String]) {
        self.ingredients = ingredientsList
    }
}
