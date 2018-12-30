//
//  MapViewController+MKMapViewDelegate.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // attempt to cast annotation as Pin object
        guard let annotation = annotation as? PinAnnotation else { return nil }
        
        // reuse identifier
        let identifier = "pin"
        
        // annotation view
        var annotationView: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.titleVisibility = .hidden
            annotationView.calloutOffset = CGPoint(x: 0, y: 5)
            annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PinAnnotation else { return }
        guard let url = URL(string: annotation.url) else { return }
        UIApplication.shared.open(url)
    }
}
