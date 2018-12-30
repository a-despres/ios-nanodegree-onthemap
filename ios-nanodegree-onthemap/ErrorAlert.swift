//
//  ErrorAlert.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/30/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

struct ErrorAlert {
    enum Alert {
        case url
        
        var alertController: UIAlertController {
            // Define standard Alert view
            let alertController = UIAlertController(title: "Something went wrong...", message: "", preferredStyle: .alert)
            
            // Add error specific message
            switch self {
            case .url: alertController.message = "Invalid URL"
            }
            
            // Add standard Dismiss button and return
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            return alertController
        }
    }
}
