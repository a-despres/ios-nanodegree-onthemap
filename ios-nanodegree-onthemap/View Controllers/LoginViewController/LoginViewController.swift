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
    var isKeyboardActive = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func handleLoginButtonTap(_ sender: UIButton) {
        // disable UI elements
        prepareUIForNetworkRequest()
        
        // make network request for postSession
        OnTheMap.postSession(username: emailTextField.text!, password: passwordTextField.text!, completion: handlePostSessionResponse(_:error:))
    }
    
    @IBAction func handleSignUpButtonTap(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url)
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign text field delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // stop activity indicator
        indicatorView.stopAnimating()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - Error Handling
extension LoginViewController {
    
    /**
     Display a UIAlertView for the given error.
     - parameter error: The error to be parsed and displayed.
     */
    private func displayAlertForError(_ error: Error) {
        switch error {
        case is OnTheMapError:
            let error = error as! OnTheMapError
            present(ErrorAlert.forStatus(error.status, parameter: error.parameter), animated: true, completion: nil)
        case is URLError:
            present(ErrorAlert.forURLError(error as! URLError), animated: true, completion: nil)
        default:
            present(ErrorAlert.forUnknownError(error), animated: true, completion: nil)
        }
    }
}

// MARK: - OnTheMap API Responses
extension LoginViewController {
    
    /**
     Handle API Response for postSession and if a successful response is returned make a call to getUserData.
     - parameter response: The PostSession object returned by the API call. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    private func handlePostSessionResponse(_ response: PostSession?, error: Error?) {
        if let error = error {
            // re-enable UI elements because of error
            resetUIAfterNetworkRequest()
            
            // display error
            displayAlertForError(error)
        } else {
            if let response = response {
                OnTheMap.getUserData(for: response.account.key, completion: handleGetUserDataResponse(_:error:))
            }
        }
    }
    
    /**
     Handle API Response for getUserData.
     - parameter response: The UserData object returned by the API call. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    private func handleGetUserDataResponse(_ response: UserData?, error: Error?) {
        // re-enable UI elements because network requests are complete
        resetUIAfterNetworkRequest()
        
        // display error or proceed
        if let error = error {
            displayAlertForError(error)
        } else {
            if let response = response {
                appDelegate.userData = response
                performSegue(withIdentifier: "loginSuccessful", sender: nil)
            }
        }
    }
}

// MARK: - Update UI
extension LoginViewController {
    
    /// Setup the UI to show that a network request is in progress.
    private func prepareUIForNetworkRequest() {
        loginButton.isEnabled = false
        loginLabel.isHidden = true
        indicatorView.startAnimating()
    }
    
    /// Setup the UI to show that the network request is completed.
    private func resetUIAfterNetworkRequest() {
        loginButton.isEnabled = true
        loginLabel.isHidden = false
        indicatorView.stopAnimating()
    }
}
