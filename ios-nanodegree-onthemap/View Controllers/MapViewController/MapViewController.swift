//
//  MapViewController.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - IBOutlets
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var downloadStatusView: UIView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func handleAddLocationButtonTap(_ sender: UIBarButtonItem) {
        // check for user data -- this should always exist so long as the user is logged in.
        guard let userData = appDelegate.userData else { return }
        
        // disable the add location button
        addLocationButton.isEnabled = false
        
        // start the getStudentLocaiton API Call
        OnTheMap.getStudentLocation(for: userData.key, completion: handleGetStudentLocationResponse(_:error:))
    }
    
    @IBAction func handleLogoutButtonTap(_ sender: UIBarButtonItem) {
        // disable logout button
        logoutButton.isEnabled = false
        
        // start the deleteSession API Call
        OnTheMap.deleteSession(completion: handleDeleteSessionResponse(_:error:))
    }
    
    @IBAction func handleRefreshButtonTap(_ sender: UIBarButtonItem) {
        // remove all existing pin annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // disable refresh button
        refreshButton.isEnabled = false
        
        // show status view
        showDownloadStatusView()
        
        // start download of student location data
        OnTheMap.getStudentLocations(completion: handleGetStudentLocationsResponse(_:error:))
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable refresh button
        refreshButton.isEnabled = false
        
        // start download of student location data
        OnTheMap.getStudentLocations(completion: handleGetStudentLocationsResponse(_:error:))
    }
}

// MARK: - Check For and Handle Existing StudentLocation
extension MapViewController {
    
    /// Display a UIAlertView to notify the user that a StudentLocation object already exists.
    private func displayAlertForExistingStudentLocation() {
        let alertController = UIAlertController(title: "Student Location Exists", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: handleOverwriteLocationTap(_:)))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Handle when the user taps the "Overwrite Location" button.
     - parameter action: The UIActionAlert button that was tapped.
     */
    private func handleOverwriteLocationTap(_ action: UIAlertAction) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
}

// MARK: - Download Status Display
extension MapViewController {
    
    /// Show the DownloadStatusView.
    private func showDownloadStatusView() {
        // position download status view
        downloadStatusView.center.y = view.frame.height - view.safeAreaInsets.bottom + downloadStatusView.frame.height / 2
        
        // show download status view
        downloadStatusView.isHidden = false
        
        // slide view into position
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.downloadStatusView.center.y -= 48
        }
    }
    
    /// Hide the DownloadStatusView.
    private func hideDownloadStatusView() {
        // slide view out of position
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.downloadStatusView.center.y += 48
            }, completion: { [unowned self] (completed) in
                // hide status view
                self.downloadStatusView.isHidden = true
        })
    }
}

// MARK: - Error Handling
extension MapViewController {
    
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

// MARK: - OnTheMap API Responses
extension MapViewController {

    /**
     Handle API Response for deleteSession.
     - parameter studentLocations: The DeleteSession object returned by the API call. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    func handleDeleteSessionResponse(_ response: DeleteSession?, error: Error?) {
        // enable the logout button
        logoutButton.isEnabled = true
        
        // display an error if needed, otherwise proceed with logging out
        if let error = error {
            displayAlertForError(error)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Handle API Response for getStudentLocation.
     - parameter studentLocations: The collection of StudentLocations. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    func handleGetStudentLocationResponse(_ response: StudentLocations?, error: Error?) {
        // enable the add location button
        addLocationButton.isEnabled = true
        
        // display an error if needed, otherwise procced with checking for an existing student location
        if let error = error {
            displayAlertForError(error)
        } else {
            if let response = response {
                if response.count > 0 {
                    appDelegate.studentLocation = response[0]
                    displayAlertForExistingStudentLocation()
                } else {
                    performSegue(withIdentifier: "addLocation", sender: nil)
                }
            }
        }
    }
    
    /**
     Handle API Response for getStudentLocations.
     - parameter studentLocations: The collection of StudentLocations. (Optional)
     - parameter error: The error returned by the API call. (Optional)
     */
    func handleGetStudentLocationsResponse(_ response: StudentLocations?, error: Error?) {
        // enable refresh button
        refreshButton.isEnabled = true
        
        // parse student location data or fail
        if let response = response {
            hideDownloadStatusView()
            appDelegate.studentLocations = response
            addPinsToMap()
        } else {
            hideDownloadStatusView()
            if let error = error { displayAlertForError(error) }
        }
    }
}

// MARK: - OnTheMap Pin Annotations
extension MapViewController {
    
    /// Parse the StudentLocations object and add pin annotations to the map.
    private func addPinsToMap() {
        
        // get studentLocations from appDelegate or fail
        guard let studentLocations = appDelegate.studentLocations else { return }
        
        // iterate through studentLocations and add pins to map
        for studentLocation in studentLocations {
            // pull values from studentLocation object...
            let student = "\(studentLocation.firstName) \(studentLocation.lastName)"
            let locationName = studentLocation.mapString
            let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            let url = studentLocation.mediaURL
            
            // ...and assign values to PinAnnotation object
            let pin = PinAnnotation(student: student, locationName: locationName, coordinate: coordinate, url: url)
            self.mapView.addAnnotation(pin)
        }
    }
}
