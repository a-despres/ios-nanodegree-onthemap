//
//  AddLocationViewController+UITextFieldDelegate.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 1/4/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleFindLocationButtonTap(findLocationButton)
        textField.resignFirstResponder()
        return true
    }
}

extension AddLocationViewController {
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
    }
    
    /**
     Adjust the origin of the view to accomodate the height of the onscreen keyboard if is determined that
     the onscreen keyboard will obscure the selected *UITextField*.
     - parameter notification: The *Notification* observed by the Notification Center.
     */
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        if findLocationButton.frame.origin.y > keyboardHeight {
            view.frame.origin.y = -keyboardHeight
        }
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
