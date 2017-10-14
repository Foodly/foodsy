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
    static var TestToken: APIToken?
    static var ProdToken: APIToken?
    @NSManaged var api_key: String!
    @NSManaged var env: String!

    class func parseClassName() -> String {
        return "ApiToken"
    }
    
    class func initializeTokensInBackground() {
        let query = PFQuery(className: "ApiToken")
        query.findObjectsInBackground { (results, error) in
            if results!.count > 0 {
                let apiTokens = results as! [APIToken]
                for apiToken in apiTokens {
                    if apiToken.env == "test" {
                        TestToken = apiToken
                    } else if apiToken.env == "prod" {
                        ProdToken = apiToken
                    }
                }
            }
        }
    }
}
