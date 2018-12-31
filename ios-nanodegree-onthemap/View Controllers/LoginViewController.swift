//
//  LoginViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func handleLoginButtonTap(_ sender: UIButton) {
        OnTheMap.postSession(username: emailTextField.text!, password: passwordTextField.text!) { [unowned self] (response, error) in
            if let response = response {
                OnTheMap.getUserData(for: response.account.key, completion: { [unowned self] (userData, error) in
                    if let userData = userData {
                        self.appDelegate.userData = userData
                    }
                })
                self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
            } else if let error = error {
                // FIXME: Add proper error handling
                print(error)
            }
        }
    }
    
    @IBAction func handleSignUpButtonTap(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url)
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // define gradient colors
        let color1 = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        let color2 = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
        
        // add gradient to view background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // modify view of loginButton
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 8
    }
}
