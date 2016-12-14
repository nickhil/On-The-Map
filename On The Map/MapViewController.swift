//
//  MapViewController.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import MapKit
import UIKit
var userPinned = false

class MapViewController : UIViewController,MKMapViewDelegate {
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMapView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshMap()
    }
    //loading the mapview with annotaion
    func loadMapView(){
            let allAnnotations = self.mapView.annotations
            mapView.removeAnnotations(allAnnotations)
            for result in StudentData.sharedInstance.mapPins {
                let annotation = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude)
                
                annotation.coordinate = location
                annotation.title = result.name
                annotation.subtitle = result.mediaURL
                
                mapView.addAnnotation(annotation)
                
                if result.name == Login.sharedInstance.name {
                    userPinned = true
                }
            }
            setUIEnabled(true)
    }
    
    //posting the pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        pinView.calloutOffset = CGPoint(x: -5, y: -5)
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        pinView.pinTintColor = .green
        return pinView
    }
    
    
    //opening the url
func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let url = view.annotation!.subtitle!
        OpenURL.sharedInstance.openBrowser(Link: url!)
    }
    
    @IBAction func pinButtonPressed(_ sender: AnyObject) {
        if userPinned {
           addMorePins(title: "Already Pinned", message: "Add one more location of the student on the map?", identifier: "Map")
        }
            else {
                performUIUpdatesOnMain {
                self.performSegue(withIdentifier: "Map", sender: self)
             }
        }
    }
    
    func refreshMap(){
        setUIEnabled(false)
        BarButtons.sharedInstance.refresh{ (refresh, errorString) in
            if refresh {
                performUIUpdatesOnMain {
                    self.loadMapView()
                }
            }
            else {
                performUIUpdatesOnMain {
                    Error.sharedInstance.showError(controller: self, title: "Failed To Refresh", message: errorString!)
                    self.setUIEnabled(true)
                }
            }
        }

    }
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        refreshMap()
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        setUIEnabled(false)
        BarButtons.sharedInstance.logout{ (logout, errorString) in
            if logout {
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                performUIUpdatesOnMain {
                    Error.sharedInstance.showError(controller: self, title: "Logout Failed", message: errorString!)
                    self.setUIEnabled(true)
                }
            }
        }
    }
    
    func setUIEnabled(_ enabled: Bool) {
        if enabled {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.mapView.alpha = 1.0
                self.logoutButton.isEnabled = true
                self.refreshButton.isEnabled = true
                self.pinButton.isEnabled = true
            }
            
        }
        else {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
                self.mapView.alpha = 0.5
                self.logoutButton.isEnabled = false
                self.refreshButton.isEnabled = false
                self.pinButton.isEnabled = false
            }
            
        }
        
    }
}




extension UIViewController {
    func addMorePins(title: String, message: String, identifier: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (result: UIAlertAction)-> Void in
        }
        
        let add = UIAlertAction(title: "Add More Pins", style: .default) { (result: UIAlertAction)-> Void in
            performUIUpdatesOnMain {
                self.performSegue(withIdentifier: identifier, sender: self)
            }
        }
        alert.addAction(cancel)
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }


}
