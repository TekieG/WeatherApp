//
//  ViewController.swift
//  Stormy
//
//  Created by Gonzalo Acuna on 10/16/14.
//  Copyright (c) 2014 Gonzalo Acuna. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    
    
    private let apiKey = "519888a010e7325f0ae0bf526d04ae82" //API Key
    let locationStatus = Bool()
    var altValue = Double()
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    //@IBOutlet weak var options: UIButton!
    @IBOutlet weak var cityAndState: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var longAndLatValue: UILabel!
    var altBool = Bool()
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
}
//****************************************************************************************
//                              DETERMINES IF SERVICES IS ENABLED
//****************************************************************************************
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.Denied || status == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            getCurrentWeatherData()
        }
        
    }
    
    func stopRefresh() {
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        self.refreshButton.hidden = false
    }
    
//****************************************************************************************
//                                    EASY DELAY FUNCTION
//****************************************************************************************
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
 //***************************************************************************************
 //                                      GETS WEATHER
 //***************************************************************************************
    
    
    func getCurrentWeatherData() -> Void {
        
        //var locValue = locationManager.location.coordinate
        //var locValue:CLLocationCoordinate2D = locationManager.location.coordinate // Gets Longitude and Latitude Coordinates
        
        //altValue = locationManager.location.altitude
        self.longAndLatValue.text = "\(locationManager.location.coordinate.latitude), \(locationManager.location.coordinate.longitude)"
        
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        //let forecastURL = NSURL(string: "28.467353,-81.304336", relativeToURL: baseURL) // Old Code
        let forecastURL = NSURL(string: "\(locationManager.location.coordinate.latitude),\(locationManager.location.coordinate.longitude)", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    self.cityAndState.text = "Still Testin"
                    self.altitudeLabel.text = "\(self.altValue) ft"
                    
                    
    
                    //Stop refresh animation
                    self.stopRefresh()
                })
                
            }
            else {
                
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //Stop refresh animation
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
                
            }
            
        })
       
        downloadTask.resume()
    }

    
    @IBAction func refresh() {
        getCurrentWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}