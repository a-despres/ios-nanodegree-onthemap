//
//  AddLocationViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: - Private Properties
    private let geocoder = CLGeocoder()
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func handleCancelButtonTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleFindLocationButtonTap(_ sender: UIButton) {
        geocodeLocation(locationTextField.text)
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change appearance of find location button and text field
        locationTextField.layer.cornerRadius = 6
        findLocationButton.layer.cornerRadius = 6
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            guard let vc = segue.destination as? ConfirmLocationViewController else { return }
            guard let placemark = sender as? CLPlacemark else { return }
            vc.placemark = placemark
        }
    }
}

// MARK: - Geocoding of Location
extension AddLocationViewController {
    private func geocodeLocation(_ location: String?) {
        if let location = location {
            geocoder.geocodeAddressString(location, completionHandler: handleGeocodeAddressStringResponse(placemarks:error:))
        }
    }
    
    private func handleGeocodeAddressStringResponse(placemarks: [CLPlacemark]?, error: Error?) {
        guard let placemark = placemarks?.first else {
            displayGeocodeError(error)
            return
        }
        performSegue(withIdentifier: "findLocation", sender: placemark)
    }
    
    private func displayGeocodeError(_ error: Error?) {
        if let error = error as? CLError {
            let alertController = UIAlertController(title: "Something went wrong...", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}
