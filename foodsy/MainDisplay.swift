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
        let ingredientListNavigationController = ingredientListStoryboard.instantiateViewController(withIdentifier: "IngredientsListNavigation") as! UINavigationController
        let ingredientListViewController = ingredientListNavigationController.topViewController as! IngredientsListViewController
        ingredientListNavigationController.navigationBar.isTranslucent = false
        ingredientListViewController.vcIdentifier = "ingredient"
        
        let shoppingListNavigationController = ingredientListStoryboard.instantiateViewController(withIdentifier: "IngredientsListNavigation") as! UINavigationController
        shoppingListNavigationController.navigationBar.isTranslucent = false
        let shoppingListViewController = shoppingListNavigationController.topViewController as! IngredientsListViewController
        shoppingListViewController.vcIdentifier = "shopping"
        
        //ingredientListNavigationController.tabBarItem.title = "Kitchen"
        
        let recipeListStoryboard = UIStoryboard(name: "RecipeList", bundle: nil)
        let recipeListNavigationController = recipeListStoryboard.instantiateViewController(withIdentifier: "RecipeListNavigationController") as! UINavigationController
        recipeListNavigationController.navigationBar.isTranslucent = false
        let recipeListViewController = recipeListNavigationController.topViewController as! RecipeListViewController
        //recipeListNavigationController.tabBarItem.title = "Recipes"
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        profileNavigationController.navigationBar.isTranslucent = false
        let profileViewController = profileNavigationController.topViewController as! ProfileViewController
        //profileNavigationController.tabBarItem.title = "Profile"
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [shoppingListNavigationController, ingredientListNavigationController, recipeListNavigationController, profileNavigationController]
        tabBarController.tabBar.items![0].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabBarController.tabBar.items![1].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabBarController.tabBar.items![2].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabBarController.tabBar.items![3].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabBarController.tabBar.items![0].image = UIImage(named: "shopping-cart")
        tabBarController.tabBar.items![1].image = UIImage(named: "ingredient-list")
        tabBarController.tabBar.items![2].image = UIImage(named: "recipes")
        tabBarController.tabBar.items![3].image = UIImage(named: "profile")
        tabBarController.tabBar.items![0].selectedImage = UIImage(named: "selected-shopping")
        tabBarController.tabBar.items![1].selectedImage = UIImage(named: "selected-ingredient")
        tabBarController.tabBar.items![2].selectedImage = UIImage(named: "selected-recipe")
        tabBarController.tabBar.items![3].selectedImage = UIImage(named: "selected-profile")
        
        /*let numberOfItems = CGFloat(tabBarController.tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBarController.tabBar.frame.width / numberOfItems, height: tabBarController.tabBar.frame.height)
        tabBarController.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: Utils.getPrimaryColor(), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)*/
        
        // remove default border
        //tabBarController.tabBar.frame.size.width = self.view.frame.width + 4
        //tabBarController.tabBar.frame.origin.x = -2
        
        tabBarController.tabBar.barTintColor = .white   
        
        return tabBarController
    }
}
