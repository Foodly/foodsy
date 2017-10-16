//
//  IngredientClient.swift
//  foodsy
//
//  Created by drishi on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import Foundation
class IngredientClient: NSObject {
    static let SharedInstance = IngredientClient()
    var baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete?number=30"

    func fetchIngredients(name: String, success: @escaping ([Ingredient])->(), failure: @escaping (Error)->()) {
        let url = URL(string: baseUrl + "&query=\(name)")
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
                    with: data, options: []) as? [NSDictionary] {
                    NSLog("response: \(responseDictionary)")
                    var ingredients = [Ingredient]()
                    for ingredient in responseDictionary {
                        ingredients.append(Ingredient(className: "Ingredient", dictionary: ingredient as? [String : Any]))
                    }
                    success(ingredients)
                }
            }
            if let error = error {
                failure(error)
            }
        }
        task.resume()
    }
    
    
}
