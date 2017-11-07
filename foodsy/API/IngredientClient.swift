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
    var baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/"
    var cache = FileCache(ttl: 10800)
    func fetchIngredients(name: String, success: @escaping ([Ingredient])->(), failure: @escaping (Error)->()) {
        let url = URL(string: baseUrl + "autocomplete?number=15&metaInformation=true&query=\(name)")
        let path = url?.query
        if let data = cache.get(user: (User.currentUser)!, path: path!) {
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
                _ = self.cache.put(user: (User.currentUser)!, path: path!, contents: data)
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
    
    func fetchIngredientByIdInParallel(ingredientIds: [NSNumber], success: @escaping ()->(), failure: @escaping (Error)->()) {
        var storedError: Error?
        let downloadGroup = DispatchGroup()
        for ingredientId in ingredientIds {
            let url = URL(string: baseUrl + "\(ingredientId)/information")
            var request = URLRequest(url: url!)
            request.setValue(APIToken.ProdToken?.api_key, forHTTPHeaderField: "X-Mashape-Key")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main
            )
            downloadGroup.enter()
            let task = session.dataTask(with: request) { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options: []) as? NSDictionary {
                        NSLog("response: \(responseDictionary)")
                        let ingredient = Ingredient(className: "Ingredient", dictionary: responseDictionary as? [String : Any])
                        ingredient.type = "shopping"
                        ingredient.saveForUser() {
                            print ("saved")
                        }
                        downloadGroup.leave()
                    }
                }
                if let error = error {
                    storedError = error
                    downloadGroup.leave()
                }
                
            }
            task.resume()
        }
        
        /*let wait = downloadGroup.wait(timeout: .now() + 4)
        
        if wait == DispatchTimeoutResult.success {
            if storedError != nil {
                failure(storedError!)
            } else {
                success()
            }
        } else {
            failure(NSError(domain:"", code:400, userInfo:nil))
        }*/
        downloadGroup.notify(queue: DispatchQueue.main) { // 2
            if storedError != nil {
                failure(storedError!)
            } else {
                success()
            }
        }
    }
    
}
