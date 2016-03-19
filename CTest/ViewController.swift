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

    @IBOutlet weak var displaySelector: NSPopUpButton!

    @IBOutlet weak var brightnessSlider: NSSlider!
    @IBOutlet weak var contrastSlider: NSSlider!
    @IBOutlet weak var logField: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initDisplaySelector()
        selectDisplay(self)
    }
    
    func logText (string: String) {
        let log = logField.documentView!
        log.textStorage!!.appendAttributedString(
            NSAttributedString(string: string + "\n")
        )
        log.scrollToEndOfDocument(nil)
    }
    
    func initDisplaySelector () {
        // remove and add items to display selector
        self.logText("Init Displays...")
        displaySelector.removeAllItems()
        for (index, display) in ddc.displays.enumerate() {

            let title = String(index)
            // not working yet
//            let (result, edid) = EDIDOfDisplay(display)
//            if result {
//                let description = [
//                    edid.descriptor1,
//                    edid.descriptor2,
//                    edid.descriptor3,
//                    edid.descriptor4
//                ].map({ (descriptor) -> String in
//                    let charTuple = descriptor.text.data
//                    let charArray = [
//                        charTuple.0, charTuple.1, charTuple.2, charTuple.3,
//                        charTuple.4, charTuple.5, charTuple.6, charTuple.7,
//                        charTuple.8, charTuple.9, charTuple.10,
//                        charTuple.11, charTuple.12
//                        ].map({(d) -> UInt8 in
//                            return UInt8(bitPattern: d)
//                        })
//                    print("Array: \(String(charArray))")
//                    if let str = NSString(bytes: charArray, length: 13, encoding: NSUTF8StringEncoding) as? String {
//                        print("Descriptor: \(str)")
//                        return str
//                    } else {
//                        return ""
//                    }
//                }).joinWithSeparator("")
//                title = "\(String(index)) - \(description)"
//            }
            print("\(String(index)) - \(String(display))")
            displaySelector.addItemWithTitle(title)
        }
    }
    
    func setCurrentValues () {
        // this does not work yet
//        let display = getSelectedDisplay()
//        brightnessSlider.intValue = Int32(ddc.readBrightness(display).currentValue)
//        contrastSlider.intValue = Int32(ddc.readContrast(display).currentValue)
    }
    
    func getSelectedDisplay() -> CGDirectDisplayID {
        let index = max(displaySelector.indexOfSelectedItem, 0);
        let display = ddc.displays[index]
        
        return display

    }
    
    func EDIDOfDisplay (displayID: CGDirectDisplayID) -> (Bool, EDID) {
        let (result, edid) = ddc.test(displayID)
        logText("Test EDID... \(String(result))")
        return (result, edid);
    }
    
    func setSliderStatus (status: Bool) {
        brightnessSlider.enabled = status
        contrastSlider.enabled = status
    }
    
    
    @IBAction func selectDisplay(sender: AnyObject) {
        let displayID = getSelectedDisplay()
        logText("Changing Display to \(String(displayID))")
        let (result, _) = EDIDOfDisplay(displayID)
        setSliderStatus(result)
        setCurrentValues()
    }
    
    
    @IBAction func ReloadDisplays(sender: AnyObject) {
        ddc.initDisplays();
        initDisplaySelector()
    }

    @IBAction func resetBrightnessAndContrast(sender: AnyObject) {
        let result = ddc.reset(getSelectedDisplay())
        logText("Resetting brightness and contrast...\(String(result))")
    }

    @IBAction func sliderCallback(sender: NSSlider) {
        let currentDisplay = getSelectedDisplay()
        let value = sender.intValue;
        // the identifier represents the value the slider wants to change
        let identifier = sender.identifier!;
        
        var result = false
        
        switch identifier {
        
        case "brightness":
            result = ddc.setBrightness(
                currentDisplay,
                brightness: UInt8(value)
            )
        case "contrast":
            result = ddc.setContrast(
                currentDisplay,
                contrast: UInt8(value)
            )
        default:
            logText("Slider with id \(identifier) not registered.")

        }
        
        logText("Setting the \(identifier) to \(String(value)) of Display value \(String(currentDisplay))... success: \(result)")

    }

}

