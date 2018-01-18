//
//  ViewController.swift
//  Detourist
//
//  Created by Lauren Cardella on 1/3/18.
//  Copyright © 2018 Lauren Cardella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI


class LoginViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("in loginViewController.viewDidLoad")
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         checkLoggedIn()
    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("user logged in")
                self.performSegue(withIdentifier: "toSearchVC", sender: nil)
            } else {
                // no user is signed in
                self.login()
            }
        }
    }

    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        authUI?.delegate = self
        authUI?.providers = providers
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            // Problem signing in
            login()
        } else {
            // User is in! Here is where we code after signing in
            checkLoggedIn()
        }
    }
    
}

