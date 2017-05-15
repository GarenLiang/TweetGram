//
//  ViewController.swift
//  TweetGram
//
//  Created by GarenLiang on 2017/5/14.
//  Copyright © 2017年 GarenLiang. All rights reserved.
//

import Cocoa
import OAuthSwift
import SwiftyJSON
class ViewController: NSViewController {
    
    @IBOutlet weak var loginlogoutButton: NSButton!
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
        //login()
        checkLogin()
    }

//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
    func checkLogin() {
        if let oauthToken = UserDefaults.standard.string(forKey: "oauthToken") {
            if let oauthTokenSecret = UserDefaults.standard.string(forKey: "oauthTokenSecret") {
                oauthswift.client.credential.oauthToken = oauthToken
                oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
                
                getTweets()
            }
        }
    }
    @IBAction func loginlogoutClicked(_ sender: Any) {
        login()
    }
    func login() {
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "TweetGram://wemadeit")!,
            success: { credential, response, parameters in
                //print(credential.oauthToken)
                //print(credential.oauthTokenSecret)
                UserDefaults.standard.set(credential.oauthToken, forKey: "oauthToken")
                UserDefaults.standard.set(credential.oauthTokenSecret, forKey: "oauthTokenSecret")
                UserDefaults.standard.synchronize()
                self.getTweets()
        },
            failure: { error in
                print(error.localizedDescription)
        }             
        )
    }
    
    func getTweets() {
        let _ = oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json",
                                      parameters: ["tweet_mode": "extended"],
                              success: { response in
//                                if let dataString = response.string {
//                                print(dataString)
//                                }
                                
                                let json = JSON(data: response.data)
                                var imageURLs : [String] = []
                                
                                for (_,tweetJson):(String, JSON) in json {
                                    for (_,mediaJson):(String, JSON) in
                                        tweetJson["entities"]["media"] {
                                            if let url = mediaJson["media_url_https"].string
                                            {
                                                imageURLs.append(url)
                                            }
                                    }
                                }
                                print(imageURLs)
         },
                              failure: { error in
                                print(error)
        }
        )
    }

}

