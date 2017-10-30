//
//  YelpClient.swift
//  foodsy
//
//  Created by drishi on 10/29/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager
import CoreLocation


// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

enum YelpSortMode: Int {
    case bestMatched = 0, distance = 1, highestRated = 2
}

class YelpClient: BDBOAuth1SessionManager {
    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init!(baseURL: URL!, consumerKey: String!, consumerSecret: String!) {
        super.init(baseURL: baseURL, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    override init(baseURL url: URL!, sessionConfiguration configuration: URLSessionConfiguration!) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }

    convenience required init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        self.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret)
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> URLSessionDataTask {
        return searchWithTerm(term, location: nil, sort: nil, deals: nil, distance:nil, offset:nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, location: CLLocationCoordinate2D?, sort: Int?, deals: Bool?, distance: String?, offset:Int?, completion: @escaping ([Business]?, Error?) -> Void) -> URLSessionDataTask {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        var llString = "37.785771,-122.406165"
        if location != nil {
            llString = "\(String.init(format: "%.2f", (location?.latitude)!)),\(String.init(format: "%.2f", (location?.longitude)!))"
        }
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": llString as AnyObject]
        
        if sort != nil && sort != -1 {
            parameters["sort"] = sort as AnyObject?
        }
        
        if offset != nil {
            parameters["offset"] = offset as AnyObject?
        }
        
        parameters["category_filter"] = "grocery" as AnyObject?
        
        if deals != nil && deals != false{
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        if distance != nil && distance != "" {
            parameters["radius_filter"] = distance! as AnyObject?
        }
        
        print(parameters)
        
        return self.get("search", parameters: parameters,
                        success: { (operation: URLSessionDataTask, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
        },
                        failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }
}
