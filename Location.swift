//
//  Location.swift
//  Stormy
//
//  Created by Gonzalo Acuna on 10/27/14.
//  Copyright (c) 2014 Gonzalo Acuna. All rights reserved.
//

import Foundation
import CoreLocation

struct location {
    
    var locationManager = CLLocationManager()
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            
            if error != nil {
                println("Reverse geocoder failed with error " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
            
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark!) {
        if placemark != nil {
            
            // Stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            println(placemark.locality)
            println(placemark.administrativeArea)
            
        }
        
    }
    
    
    
}
