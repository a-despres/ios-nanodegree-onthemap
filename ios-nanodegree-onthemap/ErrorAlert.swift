//
//  ErrorAlert.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/30/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

struct ErrorAlert {
    private static let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    
    private enum Message {
        case location(Int?)
        case login(String?)
        case url(Int?)
        
        var stringValue: String {
            switch self {
            case .location(let code):
                switch code {
                case 2: return "A Network Error Occurred"
                case 8, 9: return "Location Not Found"
                default: return "Location Unknown"
                }
            case .login(let parameter):
                switch parameter {
                case "udacity.password": return "Invalid or Missing Password"
                case "udacity.username": return "Invalid or Missing E-Mail Address"
                default: return "Account Not Found or Invalid Credentials"
                }
            case .url(let code):
                switch code {
                case -1001: return "Network Request Timed Out"
                default: return "A Network Error Occurred"
                }
            }
        }
    }
    
    private enum Title: String {
        case location = "Location Error"
        case login = "Could Not Login"
        case url = "Network Error"
    }
    
    static func forLocationError(_ error: CLError) -> UIAlertController {
        // Define alert view
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        
        // Add error specific title and message
        alertController.title = Title.location.rawValue
        alertController.message = Message.location(error.code.rawValue).stringValue
        
        // Add dismiss button and return
        alertController.addAction(dismissAction)
        return alertController
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
    
    static func forURLError(_ error: URLError) -> UIAlertController {
        // Define alert view
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        
        // Add error specific title and message
        alertController.title = Title.url.rawValue
        alertController.message = Message.url(error.code.rawValue).stringValue
        
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
