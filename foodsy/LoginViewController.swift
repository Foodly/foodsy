//
//  ViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/10/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.login(success: { () -> () in
            print("I'm logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: {(error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
}

