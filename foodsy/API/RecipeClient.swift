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
    
    func fetchRecipes(params: NSDictionary?, success: @escaping ([Recipe])->(), failure: @escaping (Error)->()) {
        var relativeUrl = baseUrl + "searchComplex?number=15&addRecipeInformation=true"
        var urlComponents = URLComponents(string : relativeUrl)!
        var queryItems = [URLQueryItem]()
        var url: URL!
        
        if let params = params {
            for key in params.allKeys {
                let valueCollections = params.value(forKey: key as! String) as! [String]
                
                for value in valueCollections {
                    queryItems.append(URLQueryItem(name: key as! String, value:value))
                }
                
            }
            urlComponents.queryItems = queryItems
            url = urlComponents.url
        } else {
            url = URL(string: relativeUrl)
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
                    //print("response: \(responseDictionary)")
                    
                    let recipesDictionary = responseDictionary["results"] as! [NSDictionary]
                    var recipes = [Recipe]()
                    for recipe in recipesDictionary {
                        let analyzedInstructions = recipe["analyzedInstructions"] as! [NSDictionary]
                        if analyzedInstructions.count > 0 {
                            recipes.append(Recipe(className: "Recipe", dictionary: recipe as? [String : Any]))
                        }
                        
                    }
                    success(recipes)
                }
            }
            if let error = error {
                failure(error)
            }
        }
        task.resume()
    }
    
    func fetchRecipe(recipeId: Int, success: @escaping (Recipe)->(), failure: @escaping (Error)->()) {
        var relativeUrl = baseUrl + "\(recipeId)/information"
        let url = URL(string: relativeUrl)
        
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
                    //print("response: \(responseDictionary)")
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
