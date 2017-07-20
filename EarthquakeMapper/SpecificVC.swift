//
//  SpecificVC.swift
//  EarthquakeMapper
//
//  Created by Kristopher Merolla on 7/19/17.
//  Copyright © 2017 Alejandro Haro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SpecificVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var specificMapView: MKMapView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    @IBAction func linkClicked(_ sender: UIButton) {
        openURL(urlStr: link)
    }
    
    func openURL(urlStr:String!) {
        if let url = NSURL(string: urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    var location: String?
    var coordinates: String?
    var magnitude: String?
    var link: String?
    
    var longitude: Double?
    var lattitude: Double?
    
    var updateSpan: Bool = true
    var pinDropCount = 0
    var rowClicked: Int = 0
    
    let manager = CLLocationManager()
    let annotation = MKPointAnnotation()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateSpan {
            //let location = locations[0]
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.6,0.6)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.lattitude!, self.longitude!)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            specificMapView.setRegion(region, animated: true)
            updateSpan = false
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.lattitude!, longitude: self.longitude!)
            //print(self.longitude)
            specificMapView.addAnnotation(annotation)
        }
        
        self.specificMapView.showsUserLocation = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = location
        coordinatesLabel.text = coordinates
        magnitudeLabel.text = magnitude
        // Do any additional setup after loading the view.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
