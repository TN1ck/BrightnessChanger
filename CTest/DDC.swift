//
//  DDC.swift
//  MonitorBrightness
//
//  Created by Tom Nick on 21/02/16.
//  Copyright © 2016 Tom Nick. All rights reserved.
//

import Foundation
import CoreGraphics


class DDC {
    
    var displays = [CGDirectDisplayID]()
    
    init () {
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
        );
        print(String(command.new_value));
        
        return DDCWrite(displayID, &command)
    }
    
    func setBrightness(displayID: CGDirectDisplayID, brightness: UInt8) {
        self.write(displayID, controlID: UInt8(BRIGHTNESS), newValue: brightness)
    }
}

