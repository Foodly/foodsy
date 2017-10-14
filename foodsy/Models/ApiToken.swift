//
//  APIToken.swift
//  foodsy
//
//  Created by drishi on 10/14/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import Foundation
import Parse

class APIToken: PFObject, PFSubclassing {
    static var _TestToken: APIToken!
    static var _ProdToken: APIToken!
    @NSManaged var api_key: String!
    @NSManaged var env: String!

    class func parseClassName() -> String {
        return "ApiToken"
    }
    
    class var TestToken: APIToken? {
        get {
            if _TestToken == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "testToken") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _TestToken = APIToken(className: "ApiToken", dictionary: dictionary as? [String : Any])
                }
            }
            return _TestToken
        }
    }
    
    class var ProdToken: APIToken? {
        get {
            if _ProdToken == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "prodToken") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _ProdToken = APIToken(className: "ApiToken", dictionary: dictionary as? [String : Any])
                }
            }
            return _ProdToken
        }
    }
    
    class func initializeTokensInBackground() {
        if TestToken != nil && ProdToken != nil {
            return
        }
        let query = PFQuery(className: "ApiToken")
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                let apiTokens = results as! [APIToken]
                for apiToken in apiTokens {
                    if apiToken.env == "test" {
                        _TestToken = apiToken
                        setTokenDataInDefaults(token: apiToken, key: "testToken")
                    } else if apiToken.env == "prod" {
                        _ProdToken = apiToken
                        setTokenDataInDefaults(token: apiToken, key: "prodToken")
                    }
                }
            }
        }
    }
    
    class func setTokenDataInDefaults(token: APIToken, key: String) {
        let data = NSMutableDictionary()
        data.setValue(token.api_key, forKey: "api_key")
        data.setValue(token.env, forKey: "env")
        let defaults = UserDefaults.standard
        let serializedData = try! JSONSerialization.data(withJSONObject: data, options: [])
        defaults.set(serializedData, forKey: key)
        
    }
    
    

}
