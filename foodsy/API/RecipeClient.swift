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
    var baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex?number=30&addRecipeInformation=true"
    
    func fetchRecipe(params: NSDictionary, success: @escaping ([Recipe])->(), failure: @escaping (Error)->()) {
        var urlComponents = URLComponents(string : baseUrl)!
        var queryItems = [URLQueryItem]()
        
        for key in params.allKeys {
            let valueCollections = params.value(forKey: key as! String) as! [String]
            
            for value in valueCollections {
                queryItems.append(URLQueryItem(name: key as! String, value:value))
            }
            
        }
        urlComponents.queryItems = queryItems
        let url = urlComponents.url
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
                print(data)
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? [NSDictionary] {
                    NSLog("response: \(responseDictionary)")
                    var recipes = [Recipe]()
                    for recipe in responseDictionary {
                        recipes.append(Recipe(className: "Recipe", dictionary: recipe as? [String : Any]))
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
    
    
}
