//
//  PushClient.swift
//  foodsy
//
//  Created by drishi on 10/29/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import Foundation

class PushClient: NSObject {
    static let SharedInstance = PushClient()
    var baseUrl = "https://cravely.herokuapp.com/parse/push"
    
    func sendReminderPush(message: String) {
        let url = URL(string: baseUrl)
        var request = URLRequest(url: url!)
        request.setValue("cravely", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("22142e23-57a2-4c24-b14e-d516a94aaeee", forHTTPHeaderField: "X-Parse-Master-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params = ["data": ["title" : "message", "alert": message], "where": ["channels": (User.currentUser?.screenname)!]]
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task = session.dataTask(with: request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                }
            }
            if let error = error {
                NSLog("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
}
