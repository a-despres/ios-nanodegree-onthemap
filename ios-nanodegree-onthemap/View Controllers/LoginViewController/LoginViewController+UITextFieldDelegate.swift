//
//  LoginViewController+UITextFieldDelegate.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 1/4/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            handleLoginButtonTap(loginButton)
        }
        return true
    }
}

extension LoginViewController {
    // MARK: - Manage Keyboard and Keyboard Notifications
    /**
     Get the height of the onscreen keyboard.
     - parameter notification: The *Notification* observed by the Notification Center.
     - returns: The height of the onscreen keyboard as a *CGFloat*.
     */
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    /**
     Reset the origin of the view to zero.
     - parameter notification: The *Notification* observed by the Notification Center.
     */
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        isKeyboardActive = false
    }
    
    /**
     Adjust the origin of the view to accomodate the height of the onscreen keyboard if is determined that
     the onscreen keyboard will obscure the selected *UITextField*.
     - parameter notification: The *Notification* observed by the Notification Center.
     */
    @objc func keyboardWillShow(_ notification: Notification) {
        if !isKeyboardActive {
            let keyboardHeight = getKeyboardHeight(notification)
            if loginButton.frame.origin.y > keyboardHeight {
                view.frame.origin.y = -(loginButton.frame.origin.y - keyboardHeight)
            }
        }
        
        // Checking for, and setting, this boolean will prevent the keyboard from
        // shifting when changing from one text field to the next.
        isKeyboardActive = true
    }
    
    /// Subscribe to the keyboardWillHide and keyboardWillShow notifications.
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    /// Unsubscribe from the keyboardWillHide and keyboardWillShow notifications.
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
