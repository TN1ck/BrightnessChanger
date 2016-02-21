//
//  ViewController.swift
//  CTest
//
//  Created by Tom Nick on 21/02/16.
//  Copyright © 2016 Tom Nick. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let ddc = DDC()

    override func viewDidLoad() {
        super.viewDidLoad()
        ddc.setBrightness(ddc.displays[1], brightness: 30)
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

