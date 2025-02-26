//
//  DisplayManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Foundation
import CoreGraphics

class DisplayManager {
    
    enum SensorMethod {
        case standard
        case m1
        case allFailed
    }
    
    enum SensorError: Error {
        enum Display: Error {
            case notFound
            case notSilicon
            case notStandard
        }
        
        enum Keyboard: Error {
            case notFound
            case notSilicon
            case notStandard
        }
    }
    
    static let shared = DisplayManager()
    
    private init() {}

    private var useM1DisplayBrightnessMethod = false

    private var method = SensorMethod.standard

    func getDisplayBrightness() throws -> Float {
        switch self.method {
        case .standard:
            do {
                return try getStandardDisplayBrightness()
            } catch {
                method = .m1
            }
        case .m1:
            do {
                return try getM1DisplayBrightness()
            } catch let error {
                method = .allFailed
            }
        case .allFailed:
            throw SensorError.Display.notFound
        }
        
        return try getDisplayBrightness()
    }

    private func getStandardDisplayBrightness() throws -> Float {
        var brightness: float_t = 1
        
        let service = IOServiceGetMatchingService(
            kIOMainPortDefault,
            IOServiceMatching(
                "IODisplayConnect"
            )
        )
        
        defer {
            IOObjectRelease(service)
        }

        let result = IODisplayGetFloatParameter(
            service,
            0,
            kIODisplayBrightnessKey as CFString,
            &brightness
        )
        
        if result != kIOReturnSuccess {
            throw SensorError.Display.notStandard
        }
        
        return brightness
    }
    
    private func getM1DisplayBrightness() throws -> Float {
        
        let task = Process()
        
        task.launchPath = "/usr/libexec/corebrightnessdiag"
        task.arguments = ["status-info"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        if let plist = try? PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil
        ) as? NSDictionary,
           let displays = plist["CBDisplays"] as? [String: [String: Any]] {
            for display in displays.values {
                if let displayInfo = display["Display"] as? [String: Any],
                    displayInfo["DisplayServicesIsBuiltInDisplay"] as? Bool == true,
                    let brightness = displayInfo["DisplayServicesBrightness"] as? Float {
                        return brightness
                }
            }
        }
        
        throw SensorError.Display.notSilicon
    }
}
