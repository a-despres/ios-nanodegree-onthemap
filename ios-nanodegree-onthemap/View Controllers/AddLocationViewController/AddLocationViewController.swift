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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func handleCancelButtonTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleFindLocationButtonTap(_ sender: UIButton) {
        // Enable the activity indicator and disable find button
        prepareUIForNetworkRequest()
        
        // Attempt to find location from string
        geocodeLocation(locationTextField.text)
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set text field delegate
        locationTextField.delegate = self
        
        // stop activity indicator
        indicatorView.stopAnimating()
        
        // Change appearance of find location button and text field
        locationTextField.layer.cornerRadius = 8
        findLocationButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - Error Handling
extension AddLocationViewController {
    
    /**
     Display a UIAlertView for the given error.
     - parameter error: The error to be parsed and displayed.
     */
    private func displayAlertForError(_ error: Error) {
        if let error = error as? CLError {
            present(ErrorAlert.forLocationError(error), animated: true, completion: nil)
        } else if let error = error as? URLError {
            present(ErrorAlert.forURLError(error), animated: true, completion: nil)
        } else {
            present(ErrorAlert.forUnknownError(error), animated: true, completion: nil)
        }
    }
}

// MARK: - Geocoding of Location
extension AddLocationViewController {
    
    /**
     Geocode the user's location based on the given location string.
     - parameter location: The string to be geocoded.
     */
    private func geocodeLocation(_ location: String?) {
        if let location = location {
            geocoder.geocodeAddressString(location, completionHandler: handleGeocodeAddressStringResponse(_:error:))
        }
    }
    
    /**
     Handle the response or error from the call to geocodeLocation(_:).
     - parameter response: An array of CLPlacemark objects returned by the call to geocodeAddressString(_:completionHandler:)
     - parameter error: The error to be parsed and displayed.
     */
    private func handleGeocodeAddressStringResponse(_ response: [CLPlacemark]?, error: Error?) {
        // reset UI now that we're back from making a network request
        resetUIAfterNetworkRequest()
        
        // handle error if necessary, otherwise handle the response
        if let error = error {
            displayAlertForError(error)
        } else {
            if let response = response {
                let placemark = response.first
                performSegue(withIdentifier: "findLocation", sender: placemark)
            }
        }
    }
}

// MARK: - Navigation
extension AddLocationViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            guard let vc = segue.destination as? ConfirmLocationViewController else { return }
            guard let placemark = sender as? CLPlacemark else { return }
            vc.placemark = placemark
        }
    }
}

// MARK: - Update UI
extension AddLocationViewController {
    
    /// Setup the UI to show that a network request is in progress.
    private func prepareUIForNetworkRequest() {
        findLocationButton.isEnabled = false
        indicatorView.startAnimating()
    }
    
    /// Setup the UI to show that the network request is completed.
    private func resetUIAfterNetworkRequest() {
        findLocationButton.isEnabled = true
        indicatorView.stopAnimating()
    }
}
