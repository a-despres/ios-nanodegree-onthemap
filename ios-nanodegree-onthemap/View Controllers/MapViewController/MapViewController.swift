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
    @IBOutlet weak var downloadStatusView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func handleAddLocationButtonTap(_ sender: UIBarButtonItem) {
        guard let userData = appDelegate.userData else { return }
        
        OnTheMap.getStudentLocation(for: userData.key) { [unowned self] (response, error) in
            if let response = response {
                if response.count > 0 {
                    self.appDelegate.studentLocation = response[0]
                    print(response[0])
                    self.displayExistingLocationAlert()
                } else {
                    self.performSegue(withIdentifier: "addLocation", sender: nil)
                }
            } else if let error = error {
                // FIXME: Add proper error handling
                print(error)
            }
        }
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
        // remove all pin annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // disable refresh button
        refreshButton.isEnabled = false
        
        // show status view
        showDownloadStatusView()
        
        // start download of student location data
        OnTheMap.getStudentLocations(completion: handleGetStudentLocationsResponse(studentLocations:error:))
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable refresh button
        refreshButton.isEnabled = false
        
        // start download of student location data
        OnTheMap.getStudentLocations(completion: handleGetStudentLocationsResponse(studentLocations:error:))
    }
    
    func handleGetStudentLocationsResponse(studentLocations: StudentLocations?, error: Error?) {
        // enable refresh button
        refreshButton.isEnabled = true
        
        // parse student location data or fail
        if let studentLocations = studentLocations {
            hideDownloadStatusView()
            appDelegate.studentLocations = studentLocations
            addPinsToMap()
        } else {
            hideDownloadStatusView()
            displayStudentLocationsError(error)
        }
    }
    
    private func addPinsToMap() {
        guard let studentLocations = appDelegate.studentLocations else { return }
        
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
    
    private func showDownloadStatusView() {
        // position download status view
        self.downloadStatusView.center.y = self.view.frame.height - self.view.safeAreaInsets.bottom + self.downloadStatusView.frame.height / 2
        
        // show download status view
        self.downloadStatusView.isHidden = false
        
        // slide view into position
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.downloadStatusView.center.y -= 48
        }
    }
    
    private func hideDownloadStatusView() {
        // slide view out of position
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.downloadStatusView.center.y += 48
            }, completion: { [unowned self] (completed) in
                // hide status view
                self.downloadStatusView.isHidden = true
        })
    }
    
    private func displayExistingLocationAlert() {
        let alertController = UIAlertController(title: "Student Location Exists", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: handleOverwriteLocationTap(_:)))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func handleOverwriteLocationTap(_ action: UIAlertAction) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    private func displayStudentLocationsError(_ error: Error?) {
        if let error = error as? URLError {
            present(ErrorAlert.Alert.studentLocations(error).alertController, animated: true, completion: nil)
        }
    }
}
