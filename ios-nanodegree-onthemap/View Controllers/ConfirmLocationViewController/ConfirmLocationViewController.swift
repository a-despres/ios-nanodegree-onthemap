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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public var placemark: CLPlacemark?
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - IBActions
    @IBAction func handleFinishButtonTap(_ sender: UIButton) {
        // Make sure that location and user data exists, else fail
        guard let locationName = placemark?.name, let location = placemark?.location else { return }
        guard let userData = appDelegate.userData else { return }
        
        // Hide the iconView, enable the activity indicatorand disable finish button
        prepareUIForNetworkRequest()
        
        // Now that we know location and user data exists, lets make a StudentLocation object to share
        let studentLocation = StudentLocation(firstName: userData.firstName,
                                              lastName: userData.lastName,
                                              latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              mapString: locationName,
                                              mediaURL: linkTextField.text!,
                                              objectId: appDelegate.studentLocation?.objectId ?? "",
                                              uniqueKey: userData.key)
        
        // share the newly created StudentLocation object
        if appDelegate.studentLocation == nil {
            // post new StudentLocation to database
            OnTheMap.postStudentLocation(studentLocation, completion: handlePostStudentLocationResponse(_:error:))
        } else {
            // update(put) StudentLocation in database
            OnTheMap.putStudentLocation(studentLocation, completion: handlePutStudentLocationResponse(_:error:))
        }
    }
    
    // MARK: - VIew Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign text field delegate
        linkTextField.delegate = self
        
        // stop activity indicator
        indicatorView.stopAnimating()
        
        // modify appearance of icon container view
        iconContainerView.layer.cornerRadius = iconContainerView.frame.height / 2
        
        // modify appearance of card view
        cardView.layer.cornerRadius = 16
        
        // modify appearance of finish button
        finishButton.layer.cornerRadius = 8
        
        // place pin and center map
        if let location = placemark?.location { markLocation(location) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // add gradient to map view as mask
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mapView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.3, 0.85, 1]
        mapView.layer.mask = gradientLayer
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
extension ConfirmLocationViewController {
    
    /**
     Display a UIAlertView for the given error.
     - parameter error: The error to be parsed and displayed.
     */
    private func displayAlertForError(_ error: Error) {
        if let error = error as? URLError {
            present(ErrorAlert.forURLError(error), animated: true, completion: nil)
        } else {
            present(ErrorAlert.forUnknownError(error), animated: true, completion: nil)
        }
    }
}

// MARK: - Map View
extension ConfirmLocationViewController {
    
    /**
     Place a pin on the map and position in view.
     - parameter location: The location to be marked with a pin.
     */
    private func markLocation(_ location: CLLocation) {
        // Define pin
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        
        // Define offset so that pin is not perfectly centered
        let edgeInsets = UIEdgeInsets(top: -0.05, left: 0, bottom: 0, right: 0)
        
        // place pin and "center" in view
        mapView.addAnnotation(pin)
        mapView.setCenter(pin.coordinate, animated: false)
        mapView.setVisibleMapRect(mapView.visibleMapRect, edgePadding: edgeInsets, animated: false)
        mapView.camera.altitude = 4096
    }
}

// MARK: - OnTheMap API Responses
extension ConfirmLocationViewController {
    
    /**
     Handle API Response for postStudentLocation.
     - parameter response: The PostStudentLocation object returned by the API call. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    private func handlePostStudentLocationResponse(_ response: PostStudentLocation?, error: Error?) {
        // reset UI now that we're back from making a network request
        resetUIAfterNetworkRequest()
        
        // handle error if necessary, otherwise handle the response
        if let error = error {
            displayAlertForError(error)
        } else {
            if let _ = response {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /**
     Handle API Response for putStudentLocation.
     - parameter response: The PutStudentLocation object returned by the API call. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    private func handlePutStudentLocationResponse(_ response: PutStudentLocation?, error: Error?) {
        // reset UI now that we're back from making a network request
        resetUIAfterNetworkRequest()
        
        // handle error if necessary, otherwise handle the response
        if let error = error {
            displayAlertForError(error)
        } else {
            if let _ = response {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Update UI
extension ConfirmLocationViewController {
    
    /// Setup the UI to show that a network request is in progress.
    private func prepareUIForNetworkRequest() {
        finishButton.isEnabled = false
        iconView.isHidden = true
        indicatorView.startAnimating()
    }
    
    /// Setup the UI to show that the network request is completed.
    private func resetUIAfterNetworkRequest() {
        finishButton.isEnabled = true
        iconView.isHidden = false
        indicatorView.stopAnimating()
    }
}
