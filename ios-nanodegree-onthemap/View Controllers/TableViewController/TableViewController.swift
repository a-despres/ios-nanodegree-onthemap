//
//  TableViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Constants
    let cellIdentifier = "cell"
    
    // MARK: - IBActions
    @IBAction func handleAddLocationButtonTap(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    @IBAction func handleLogoutButtonTap(_ sender: UIBarButtonItem) {
        OnTheMap.deleteSession { [unowned self] (response, error) in
            if let _ = response {
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                // FIXME: Add proper error handling
                print(error)
            }
        }
    }
    
    @IBAction func handleRefreshButtonTap(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
