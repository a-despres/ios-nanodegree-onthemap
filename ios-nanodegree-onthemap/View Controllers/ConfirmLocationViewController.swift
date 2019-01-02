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
        guard let locationName = placemark?.name, let location = placemark?.location else {
            return
        }
        
        guard let userData = appDelegate.userData else {
            return
        }
        
        let studentLocation = StudentLocation(firstName: userData.firstName,
                                              lastName: userData.lastName,
                                              latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              mapString: locationName,
                                              mediaURL: linkTextField.text!,
                                              objectId: appDelegate.studentLocation?.objectId ?? "",
                                              uniqueKey: userData.key)
        
        if appDelegate.studentLocation == nil {
            // post new student location to database
            OnTheMap.postStudentLocation(studentLocation) { [unowned self] (response, error) in
                if let _ = response {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    if let error = error {
                        self.present(ErrorAlert.Alert.postStudentLocation(error).alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // update(put) student location in database
            OnTheMap.putStudentLocation(studentLocation) { [unowned self] (response, error) in
                if let _ = response {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                } else if let error = error {
                    self.present(ErrorAlert.Alert.postStudentLocation(error).alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - VIew Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // stop activity indicator
        indicatorView.stopAnimating()
        
        // modify appearance of icon container view
        iconContainerView.layer.cornerRadius = iconContainerView.frame.height / 2
        
        // modify appearance of card view
        cardView.layer.cornerRadius = 16
        
        // modify appearance of finish button
        finishButton.layer.cornerRadius = 8
        
        // place pin and center map
        if let location = placemark?.location {
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate

            self.mapView.setCenter(pin.coordinate, animated: false)
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: -0.05, left: 0, bottom: 0, right: 0), animated: false)

            self.mapView.camera.altitude = 4096
            self.mapView.addAnnotation(pin)
        }
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
}
