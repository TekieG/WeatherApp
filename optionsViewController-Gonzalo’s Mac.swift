//
//  optionsViewController.swift
//  Stormy
//
//  Created by Gonzalo Acuna on 10/27/14.
//  Copyright (c) 2014 Gonzalo Acuna. All rights reserved.
//

import Foundation
import UIKit

class optionsViewController : UIViewController {
    
    @IBOutlet weak var showAltitudeSwitch: UISwitch!
    @IBAction func switchPressed(sender: AnyObject) {
        if showAltitudeSwitch.on {
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

