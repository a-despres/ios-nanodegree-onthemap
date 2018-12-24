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
        performSegue(withIdentifier: "loginSuccessful", sender: nil)
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
