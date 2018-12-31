//
//  ErrorAlert.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/30/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

struct ErrorAlert {
    private static let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    
    private enum Message {
        case login(String?)
        
        var stringValue: String {
            switch self {
            case .login(let parameter):
                switch parameter {
                case "udacity.password": return "Invalid or Missing Password"
                case "udacity.username": return "Invalid or Missing E-Mail Address"
                default: return "Account Not Found or Invalid Credentials"
                }
            }
        }
    }
    
    private enum Title: String {
        case login = "Could Not Login"
    }

    static func forStatus(_ status: Int, parameter: String? = nil) -> UIAlertController {
        // Define alert view
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        
        // Add error specific title and message
        switch status {
        case 400, 403:
            alertController.title = Title.login.rawValue
            alertController.message = Message.login(parameter).stringValue
        default: alertController.message = "Unknown Error"
        }
        
        // Add dismiss button and return
        alertController.addAction(dismissAction)
        return alertController
    }
    
    static func forUnknownError(_ error: Error) -> UIAlertController {
        // Define alert view
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
    
        // Add error message
        alertController.message = error.localizedDescription
        
        // Add dismiss button and return
        alertController.addAction(dismissAction)
        return alertController
    }
    
    // TODO: - Refactor the below code
    enum Alert {
        case url
        case postStudentLocation(Error)
        case studentLocations(Error)
        
        var alertController: UIAlertController {
            // Define standard Alert view
            let alertController = UIAlertController(title: "Something went wrong...", message: "", preferredStyle: .alert)
            
            // Add error specific message
            switch self {
            case .url: alertController.message = "Invalid URL"
            case .postStudentLocation(let error): alertController.message = error.localizedDescription
            case .studentLocations(let error): alertController.message = error.localizedDescription
            }
            
            // Add standard Dismiss button and return
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            return alertController
        }
    }
}
