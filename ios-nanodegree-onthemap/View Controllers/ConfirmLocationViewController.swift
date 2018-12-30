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
    public var placemark: CLPlacemark?
    
    // MARK: - IBOutlets
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - IBActions
    @IBAction func handleFinishButtonTap(_ sender: UIButton) {
        guard let locationName = placemark?.name, let location = placemark?.location else {
            return
        }
        
        // Temporary values -- these will likely be updated after implementing login functionality
        let studentLocation = StudentLocation(firstName: "Andrew",
                                              lastName: "Despres",
                                              latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              mapString: locationName,
                                              mediaURL: linkTextField.text!,
                                              objectId: "",
                                              uniqueKey: "ad1234")
        
        OnTheMap.postStudentLocation(studentLocation) { [unowned self] (response, error) in
            if let _ = response {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                if let error = error {
                    self.present(ErrorAlert.Alert.postStudentLocation(error).alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - VIew Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = placemark?.location {
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate

            self.mapView.setCenter(location.coordinate, animated: true)
            self.mapView.camera.altitude = 4096
            self.mapView.addAnnotation(pin)
        }
    }
}
