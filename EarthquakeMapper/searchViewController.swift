//
//  searchViewController.swift
//  EarthquakeMapper
//
//  Created by Alejandro Haro on 7/19/17.
//  Copyright © 2017 Alejandro Haro. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var magInput: UITextField!
    @IBOutlet weak var regionInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.magInput.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        magInput.resignFirstResponder()
        return (true)
    }
}
