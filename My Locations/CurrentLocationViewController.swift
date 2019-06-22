//
//  FirstViewController.swift
//  My Locations
//
//  Created by demas on 22/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    
    @IBAction func getLocations() {
        
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationDeniedServicesDeniedAlert()
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
        
        updateLabels()
        configureGetButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        configureGetButton()
        // Do any additional setup after loading the view.
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
    
        lastLocationError = error as NSError
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last as! CLLocation
        print("didUpdateLocation \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil ||
            location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            lastLocationError = nil
            location = newLocation
            updateLabels()
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We've done!")
                stopLocationManager()
                configureGetButton()
            }
        }
        
        
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func updateLabels() {
        
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude )
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude )
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
        
        var statusMessage: String
        if let error = lastLocationError {
            if error.domain == kCLErrorDomain &&
                error.code == CLError.denied.rawValue {
                statusMessage = "Location services disabled"
            } else {
                statusMessage = "Error getting location"
            }
        } else if !CLLocationManager.locationServicesEnabled() {
            statusMessage = "Location services disabled"
        } else if updatingLocation {
            statusMessage = "Searching..."
        } else {
            statusMessage = "Tap 'Get My Location' to start"
        }
        
        messageLabel.text = statusMessage
    }

    func configureGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    func showLocationDeniedServicesDeniedAlert() {
         let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settigns", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}

