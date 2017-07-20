//
//  ViewController.swift
//  EarthquakeMapper
//
//  Created by Alejandro Haro on 7/19/17.
//  Copyright © 2017 Alejandro Haro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {
    
    var earthquakes = [NSDictionary]()
    
    
    @IBOutlet weak var recentTableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateSpan: Bool = true
    var pinDropCount = 0
    var rowClicked: Int = 0
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateSpan {
            let location = locations[0]
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.6,0.6)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region, animated: true)
            updateSpan = false
            //annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //mapView.addAnnotation(annotation)
        }
        
        self.mapView.showsUserLocation = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        ETQModel.getAllEarthquakes(completionHandler: {
            data, response, error in
            do {
                print("inside the do")
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let quakeArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    print("inside the json result")
                    for quake in quakeArray {
                        self.earthquakes.append(quake as! NSDictionary)
                    }
                }
                DispatchQueue.main.async {
                    //print(self.earthquakes)
                    self.recentTableView.reloadData()
                    for quake in self.earthquakes {
                        let message = quake["msg"] as! NSDictionary
                        let geometry = message["geometry"] as! NSDictionary
                        let coordinates = geometry["coordinates"] as! NSArray
                        let longitude = coordinates[0] as! Double
                        let lattitude = coordinates[1] as! Double
                        //print(lattitude, longitude)
                        if self.pinDropCount < 100 {
                            self.dropPin(lattitude, long: longitude)
                            self.pinDropCount += 1
                        }
                    }
                }
            } catch {
                print("Something went wrong")
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dropPin(_ lat: Double, long: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
    }
    
    
    //this is the function that prints the row in the console, we need to
    //take the data from the rowin and display it in the next page. 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section: \(indexPath.section) and Row: \(indexPath.row)")
        self.rowClicked = indexPath.row
        print(self.rowClicked)
        performSegue(withIdentifier: "SpecificQuakeSegue", sender: indexPath)
        //print(indexPath.row)
        //print(earthquakes[indexPath.row]
        //tableView.reloadData()
    }
    
    // need to override the prepare for segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let specificVC = navigationController.topViewController as! SpecificVC
        //specificVC.delegate = self as! SpecificVCDelegate
        // use sent index path to set item in table view controller
        //let indexPath = sender as! NSIndexPath
        //print(indexPath.row)
        //let item = items[indexPath.row]
        let message = earthquakes[self.rowClicked]["msg"] as! NSDictionary
        let properties = message["properties"] as! NSDictionary
        let title = properties["place"]
        let url = properties["url"]
        let magnitude = properties["mag"] as! Double
        let magNumber = magnitude as NSNumber
        let magString: String = magNumber.stringValue
        let geometry = message["geometry"] as! NSDictionary
        let coordinates = geometry["coordinates"] as! NSArray
        let longitude = coordinates[0] as! Double
        let lattitude = coordinates[1] as! Double
        let longString: String = String(format:"%f",longitude)
        let latString: String = String(format:"%f",lattitude)
        let coordinateString = latString + " , " + longString
        specificVC.lattitude = lattitude
        specificVC.longitude = longitude
        specificVC.location = title as? String
        specificVC.coordinates = coordinateString
        specificVC.magnitude = magString
        specificVC.link = url as! String
    }
    
    
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        print("unwound to main view controller!")
        //self.rowClicked = 0
    }
    
    
}
   
extension ViewController: UITableViewDataSource {
    
    // for the edit functionality (better UI look!)
    //func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // use the sender (indexPath) to retrieve the item from the array
      //  print("performing segue")
        //performSegue(withIdentifier: "SpecificQuakeSegue", sender: indexPath)
   //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }
    
    // how should I create each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        // set text label to the model that is corresponding to the row in array
        let message = earthquakes[indexPath.row]["msg"] as! NSDictionary
        let properties = message["properties"] as! NSDictionary
        let title = properties["place"]
        let magnitude = properties["mag"] as! Double
        let magNumber = magnitude as NSNumber
        let magString: String = magNumber.stringValue
        print(title ?? "no title")
        cell.textLabel?.text = title as? String
        cell.detailTextLabel?.text = magString
        // return cell so that Table View knows what to render in each row
        return cell
    }
}














