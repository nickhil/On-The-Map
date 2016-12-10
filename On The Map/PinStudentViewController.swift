//
//  PinStudentViewController.swift
//  On The Map
//
//  Created by Nikhil on 09/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import MapKit
import UIKit


class PinStudentViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var submitView: UIStackView!
    @IBOutlet weak var findView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    let textFieldDelegate = TextFieldDelegate()
    var coordinates: CLLocationCoordinate2D!
    
    @IBAction func cancelButton(_ sender: AnyObject) {
      self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = textFieldDelegate
        locationTextField.delegate = textFieldDelegate
        initialView()
    }
   
    func initialView(){
        submitView.isHidden = true
        findView.isHidden = false
    }
    
    @IBAction func findLocation(_ sender: AnyObject) {
        self.setUIEnabled(enabled: false)
        let location = self.locationTextField.text
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location!, completionHandler: { (placemark, error)-> Void in
            if error != nil {
                performUIUpdatesOnMain {
                    Error.sharedInstance.showError(controller: self, title: "Geocoder Error", message: "Location Not Found ! Please enter a valid location")
                }
                self.setUIEnabled(enabled: true)
            }
            else if placemark?[0] != nil {
                let placemark: CLPlacemark = placemark![0]
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                self.mapView?.addAnnotation(pointAnnotation)
                self.mapView?.centerCoordinate = coordinates
                self.mapView?.camera.altitude = 20000
                self.coordinates = coordinates
                self.changeView()
            }
        } )
    }
    
        @IBAction func submitDetails(_ sender: AnyObject) {
        self.setUIEnabled(enabled: false)
        StudentLocation.sharedInstance.postingStudentLocation(coordinates.latitude.description , longitude: coordinates.longitude.description, addressField: locationTextField.text!, link: linkTextField.text!) { (sucess,error) in
            if sucess {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                performUIUpdatesOnMain {
                    Error.sharedInstance.showError(controller: self, title: "Location posting error", message: error!)
                }
            }
        }
    }
    
    func setUIEnabled(enabled: Bool) {
        locationTextField.isEnabled = true
        submitButton.isEnabled = true
        findButton.isEnabled = true
        linkTextField.isEnabled = true
        if enabled {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.locationTextField.alpha = 1.0
                self.submitButton.alpha = 1.0
                self.findButton.alpha = 1.0
                self.linkTextField.alpha = 1.0
                self.mapView.alpha = 1.0
                self.studyLabel.alpha = 1.0
            }
        }
        else {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
                self.locationTextField.alpha = 0.5
                self.submitButton.alpha = 0.5
                self.findButton.alpha = 0.5
                self.linkTextField.alpha = 0.5
                self.mapView.alpha = 0.5
                self.studyLabel.alpha = 0.5
            }
        }
    }

    func changeView() {
        setUIEnabled(enabled: true)
        submitView.isHidden = false
        findView.isHidden = true
    }
}
