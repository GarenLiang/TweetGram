//
//  ViewController.swift
//  TweetGram
//
//  Created by GarenLiang on 2017/5/14.
//  Copyright © 2017年 GarenLiang. All rights reserved.
//

import Cocoa
import OAuthSwift

class ViewController: NSViewController {
    
    let oauthswift = OAuth1Swift(
        consumerKey:    "",
        consumerSecret: "",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        login()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func login() {
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "TweetGram://wemadeit")!,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                self.getFollowers()
        },
            failure: { error in
                print(error.localizedDescription)
        }             
        )
    }
    
    func getFollowers() {
        let _ = oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json",
                              success: { response in
                                if let dataString = response.string {
                                print(dataString)
                                }
        },
                              failure: { error in
                                print(error)
        }
        )
    }

}

