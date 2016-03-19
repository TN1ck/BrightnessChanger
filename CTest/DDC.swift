//
//  DDC.swift
//  MonitorBrightness
//
//  Created by Tom Nick on 21/02/16.
//  Copyright © 2016 Tom Nick. All rights reserved.
//

import Foundation
import CoreGraphics

struct DDCReadResult {
    var controlID: UInt8
    var maxValue: UInt8
    var currentValue: UInt8
}

struct ControlIDs {
    
}

class DDC {
    
    var displays = [CGDirectDisplayID]()
    
    init () {
        self.initDisplays()
    }
    
    func initDisplays () {
        displays.removeAll()
        // https://gist.github.com/kballard/569d5ba0f1b0961a15c0
        var displayCount: UInt32 = 0;
        var result = CGGetActiveDisplayList(0, nil, &displayCount)
        if (Int(result.rawValue) != 0) {
            print("error: \(result)")
            return
        }
        let allocated = Int(displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.alloc(allocated)
        result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        if (Int(result.rawValue) != 0) {
            print("error: \(result)")
            return
        }
        print("\(displayCount) displays:")
        for i in 0..<displayCount {
            print("[\(i)] - \(activeDisplays[Int(i)])")
            self.displays.append(activeDisplays[Int(i)])
        }
        activeDisplays.dealloc(allocated)
    }
    
    func write (displayID: CGDirectDisplayID, controlID : UInt8, newValue : UInt8) -> Bool {
        var command = DDCWriteCommand(
            control_id: controlID, new_value: newValue
        )
        
        let result = DDCWrite(displayID, &command)
        print("Command \(String(command.new_value)): \(String(result))")
        
        return result
    }
    
    func read (displayID: CGDirectDisplayID, controlID: UInt8) -> DDCReadResult {
        var command = DDCReadCommand(
            control_id: controlID, max_value: 0, current_value: 0
        )
        DDCRead(displayID, &command)
        print("Current Value: \(String(command.current_value))")
        return DDCReadResult(
            controlID: controlID,
            maxValue: command.max_value,
            currentValue: command.current_value
        )
    }
    
    func test (displayID: CGDirectDisplayID) -> (Bool, EDID) {
        var edid = EDID()
        let result = EDIDTest(displayID, &edid)
        print("EDID Test for Display \(String(displayID)) - \(String(result))")
        return (result, edid)
    }
    
    func setBrightness(displayID: CGDirectDisplayID, brightness: UInt8) -> Bool {
        return self.write(displayID, controlID: UInt8(BRIGHTNESS), newValue: brightness)
    }
    
    func readBrightness(displayID: CGDirectDisplayID) -> DDCReadResult {
        return self.read(displayID, controlID: UInt8(BRIGHTNESS))
    }
    
    func readContrast(displayID: CGDirectDisplayID) -> DDCReadResult {
        return self.read(displayID, controlID: UInt8(CONTRAST))
    }
    
    func setContrast(displayID: CGDirectDisplayID, contrast: UInt8) -> Bool {
        return self.write(displayID, controlID: UInt8(CONTRAST), newValue: contrast)
    }
    
    func reset(displayID: CGDirectDisplayID) -> Bool {
        return self.write(displayID, controlID: UInt8(RESET), newValue: 100)
    }
}

