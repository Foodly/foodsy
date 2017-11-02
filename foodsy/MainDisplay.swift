//
//  MainDisplay.swift
//  foodsy
//
//  Created by hsherchan on 11/1/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class MainDisplay: NSObject {
    static func getMainTabbarController() -> UITabBarController {
        let ingredientListStoryboard = UIStoryboard(name: "IngredientList", bundle: nil)
        let shoppingListNavigationController = ingredientListStoryboard.instantiateViewController(withIdentifier: "IngredientsListNavigation") as! UINavigationController
        let shoppingListViewController = shoppingListNavigationController.topViewController as! IngredientsListViewController
        shoppingListViewController.vcIdentifier = "shopping"
        
        let ingredientListNavigationController = ingredientListStoryboard.instantiateViewController(withIdentifier: "IngredientsListNavigation") as! UINavigationController
        let ingredientListViewController = ingredientListNavigationController.topViewController as! IngredientsListViewController
        ingredientListViewController.vcIdentifier = "ingredient"
        ingredientListNavigationController.tabBarItem.title = "Kitchen"
        
        let recipeListStoryboard = UIStoryboard(name: "RecipeList", bundle: nil)
        let recipeListNavigationController = recipeListStoryboard.instantiateViewController(withIdentifier: "RecipeListNavigationController") as! UINavigationController
        let recipeListViewController = recipeListNavigationController.topViewController as! RecipeListViewController
        recipeListNavigationController.tabBarItem.title = "Recipes"
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        let profileViewController = profileNavigationController.topViewController as! ProfileViewController
        profileNavigationController.tabBarItem.title = "Profile"
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [shoppingListNavigationController, ingredientListNavigationController, recipeListNavigationController, profileNavigationController]
        tabBarController.tabBar.items![0].image = #imageLiteral(resourceName: "shopping-cart")
        tabBarController.tabBar.items![1].image = #imageLiteral(resourceName: "ingredient-list")
        tabBarController.tabBar.items![2].image = #imageLiteral(resourceName: "recipes")
        tabBarController.tabBar.items![3].image = #imageLiteral(resourceName: "profile")
        
        return tabBarController
    }
}
