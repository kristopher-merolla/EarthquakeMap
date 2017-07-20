//
//  etqModel.swift
//  EarthquakeMapper
//
//  Created by Kristopher Merolla on 7/19/17.
//  Copyright © 2017 Alejandro Haro. All rights reserved.
//

import Foundation

class ETQModel {
    // Note that we are passing in a function to the getAllPeople method (similar to our use of callbacks in JS). This function will allow the ViewController that calls this method to dictate what runs upon completion.
    static func getAllEarthquakes(completionHandler:@escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        // Specify the url that we will be sending the GET Request to
        let url = URL(string: "http://13.58.55.198/eqts")
        // Create a URLSession to handle the request tasks
        
        let session = URLSession.shared
        
        // Create a "data task" which will request some data from a URL and then run the completion handler that we are passing into the getAllEarthquakes function itself
        
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
    }
    
    
}
