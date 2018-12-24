//
//  ConfirmLocationViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

class ConfirmLocationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var linkTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func handleFinishButtonTap(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VIew Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
