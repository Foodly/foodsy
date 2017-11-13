//
//  RecipeClient.swift
//  foodsy
//
//  Created by hsherchan on 10/16/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

import Foundation

class RecipeClient: NSObject {
    static let SharedInstance = RecipeClient()
    var baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/"
    var cache = FileCache(ttl: 10800)
    func fetchRecipes(params: NSDictionary?, success: @escaping ([Recipe])->(), failure: @escaping (Error)->()) {
        let relativeUrl = baseUrl + "searchComplex?"
        var urlComponents = URLComponents(string : relativeUrl)!
        var queryItems = [URLQueryItem]()
        var url: URL!
        
        if let params = params {
            for key in params.allKeys {
                let valueCollections = params.value(forKey: key as! String) as! [String]
                
                if valueCollections.count > 0 {
                    var queryString = ""
                    
                    for (index, value) in valueCollections.enumerated() {
                        if (index == 0) {
                            queryString = queryString + value
                        } else {
                            queryString = "\(queryString) \(value)"
                        }
                    }
                    queryItems.append(URLQueryItem(name: key as! String, value:queryString))
                }
                
                
            }
        }
        queryItems.append(URLQueryItem(name: "number", value: "15"))
        queryItems.append(URLQueryItem(name: "addRecipeInformation", value: "true"))
        urlComponents.queryItems = queryItems
        url = urlComponents.url
        let path = url.query!
        if let data = cache.get(user: (User.currentUser)!, path: path) {
            if let responseDictionary = try! JSONSerialization.jsonObject(
                with: data, options: []) as? NSDictionary {
                let recipesDictionary = responseDictionary["results"] as! [NSDictionary]
                var recipes = [Recipe]()
                for recipe in recipesDictionary {
                    let analyzedInstructions = recipe["analyzedInstructions"] as? [NSDictionary]
                    if let analyzedInstructions = analyzedInstructions {
                        if analyzedInstructions.count > 0 {
                            recipes.append(Recipe(className: "Recipe", dictionary: recipe as? [String : Any]))
                        }
                    }
                }
                success(recipes)
            }
        }
        
        var request = URLRequest(url: url!)
        request.setValue(APIToken.ProdToken?.api_key, forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task = session.dataTask(with: request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? NSDictionary {
                    _ = self.cache.put(user: (User.currentUser)!, path: path, contents: data)
                    let recipesDictionary = responseDictionary["results"] as! [NSDictionary]
                    var recipes = [Recipe]()
                    for recipe in recipesDictionary {
                        let analyzedInstructions = recipe["analyzedInstructions"] as? [NSDictionary]
                        if let analyzedInstructions = analyzedInstructions {
                            if analyzedInstructions.count > 0 {
                                recipes.append(Recipe(className: "Recipe", dictionary: recipe as? [String : Any]))
                            }
                        }
                        
                        
                    }
                    success(recipes)
                } else {
                    
                }
            }
            if let error = error {
                failure(error)
            }
        }
        task.resume()
    }
    
    func fetchRecipe(recipeId: Int, success: @escaping (Recipe)->(), failure: @escaping (Error)->()) {
        let relativeUrl = baseUrl + "\(recipeId)/information"
        let url = URL(string: relativeUrl)
        let relativePath = url?.relativePath
        if let data = cache.get(user: (User.currentUser)!, path: relativePath!) {
            if let responseDictionary = try! JSONSerialization.jsonObject(
                with: data, options: []) as? NSDictionary {
                let recipe = Recipe(className: "Recipe", dictionary: responseDictionary as? [String : Any]);
                success(recipe)
            }
        }
        
        var request = URLRequest(url: url!)
        request.setValue(APIToken.ProdToken?.api_key, forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task = session.dataTask(with: request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? NSDictionary {
                    _ = self.cache.put(user: (User.currentUser)!, path: relativePath!, contents: data)
                    let recipe = Recipe(className: "Recipe", dictionary: responseDictionary as? [String : Any]);
                    success(recipe)
                }
            }
            if let error = error {
                failure(error)
            }
        }
        task.resume()
    }
    
    
}
