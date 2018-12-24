//
//  ConfirmLocationViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {

    // MARK: - Properties
    public var location: CLLocation?
    
    // MARK: - IBOutlets
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - IBActions
    @IBAction func handleFinishButtonTap(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VIew Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = location {
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate

            self.mapView.setCenter(location.coordinate, animated: true)
            self.mapView.camera.altitude = 4096
            self.mapView.addAnnotation(pin)
        }
    }
}
