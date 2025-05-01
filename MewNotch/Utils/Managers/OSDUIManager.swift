//
//  OSDUIManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Foundation

class OSDUIManager {
    
    static let shared = OSDUIManager()
    
    private init() {}

    public func start() {
        do {
            let task = Process()
            
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-9", "OSDUIHelper"]
            
            try task.run()
        } catch {
            NSLog("Error while trying to re-enable OSDUIHelper. \(error)")
        }
    }

    public func stop() {
        do {
            let kickstart = Process()
            
            kickstart.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            
            // When macOS boots, OSDUIHelper does not start until a volume button is pressed. We can workaround this by kickstarting it.
            
            kickstart.arguments = ["kickstart", "gui/\(getuid())/com.apple.OSDUIHelper"]
            
            try kickstart.run()
            kickstart.waitUntilExit()
            
            usleep(1000000) // Make sure it started
            
            let task = Process()
            
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-STOP", "OSDUIHelper"]
            
            try task.run()
        } catch {
            NSLog("Error while trying to hide OSDUIHelper. Please create an issue on GitHub. Error: \(error)")
        }
    }
    
    public func reset() {
        start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.stop()
        }
    }
}
