//
//  IsResisteredViewController.swift
//  Buzztter
//
//  Created by kou yamamoto on 2021/01/08.
//

import UIKit

class IsResisteredViewController: UIViewController {
    
    let userDefalut = UserDefaults.standard
    
    override func viewDidLoad() {
        //userDefalut.removePersistentDomain(forName: "kouyamamoto.Buzztter")
    }

    override func viewDidAppear(_ animated: Bool) {
        isRegsteredUser()
    }
    
    func isRegsteredUser() {
        if let oAuthToken = userDefalut.string(forKey: "oAuthToken"), let oAuthSecretToken = userDefalut.string(forKey: "oAuthSecretToken") {
            print(oAuthToken)
            print(oAuthSecretToken)
            self.performSegue(withIdentifier: "to_tweets_list_vc", sender: nil)
        } else {
            self.performSegue(withIdentifier: "to_authorization_vc", sender: nil)
            print("登録されてないよ")
        }
    }
}
