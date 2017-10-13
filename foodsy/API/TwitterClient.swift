//
//  TwitterClient.swift
//  foodsy
//
//  Created by drishi on 10/12/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

//
//  TwitterClient.swift
//  tweeter
//
//  Created by drishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL, consumerKey: "qFIop5Itn47DKNfFFWN3QpqW3", consumerSecret: "FuG0pSTIcl3MDpbWarUpHnIkO6LWdHwvPRI9TMlQufuDqE8Ksx")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func currentAccount(success: @escaping (User)->(), failure: @escaping (Error)->()) {
        get("/1.1/account/verify_credentials.json", parameters: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(data: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //self.currentAccount()
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
                self.loginFailure?(error)
            })
        }) {(error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "foodsy://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let string = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token.description)"
            if let url = URL(string: string) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }, failure: { (error: Error!) in
            print("Error: \(String(describing: error?.localizedDescription)) ")
            self.loginFailure?(error)
        })
    }
}

