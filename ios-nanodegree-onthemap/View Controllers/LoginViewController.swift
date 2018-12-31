//
//  LoginViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func handleLoginButtonTap(_ sender: UIButton) {
        OnTheMap.postSession(username: emailTextField.text!, password: passwordTextField.text!) { [unowned self] (response, error) in
            if let _ = response {
                self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
            } else if let error = error {
                // FIXME: Add proper error handling
                print(error)
            }
        }
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
