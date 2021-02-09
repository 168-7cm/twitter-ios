//
//  ViewController.swift
//  Buzztter
//
//  Created by kou yamamoto on 2021/01/06.
//


import Swifter
import UIKit
import SafariServices

class AuthorizationViewController: UIViewController {
    
    private var swifter = Swifter(
        consumerKey: "ZSvKGOHjFxeX8im8katf7RC4i",
        consumerSecret: "djqFCpF3lKZiAaxSSYONS1F9abmJt1ikF8WWtIPAGjnRxrcWef"
    )
    
    var oAuthToken: String!
    var oAuthSecretToken: String!
    let registerViewController = IsResisteredViewController()
    
    override func viewDidLoad() {
    }
    
    //Twitterの認証
    private func authorize(swifter: Swifter) {
        swifter.authorize(
            withCallback: URL(string: "swifter-ZSvKGOHjFxeX8im8katf7RC4i://")!,
            presentingFrom: self,
            success: { [self] accessToken, response in
                
                guard let accessToken = accessToken else {
                    return
                }
                
                //UserDefaultにトークン保存
                self.oAuthToken = accessToken.key
                self.oAuthSecretToken = accessToken.secret
                
                registerViewController.userDefalut.set(oAuthToken, forKey: "oAuthToken")
                registerViewController.userDefalut.set(oAuthSecretToken, forKey: "oAuthSecretToken")
                
                self.performSegue(withIdentifier: "to_tweets_list_vc", sender: nil)
                
            }, failure: { error in
                print(error)
            })
    }
    
    //Twitterログイン
    @IBAction func loginWithTwitter(_ sender: Any) {
        authorize(swifter: swifter)
    }
}

extension AuthorizationViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
