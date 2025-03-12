//
//  MewAppDelegate.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

class MewAppDelegate: NSObject, NSApplicationDelegate {
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.openSettings) var openSettingsWindow
    
    var windows: [NSScreen: NSWindow] = [:]
    
    var window: NSWindow!
    
    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return false
    }
    
    func applicationWillTerminate(
        _ notification: Notification
    ) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationDidFinishLaunching(
        _ notification: Notification
    ) {
        if MewDefaultsManager.shared.hudEnabled {
            OSDUIManager.shared.stop()
        }
        
        // Need to Initialise once to set system listeners
        AudioInput.sharedInstance()
        AudioOutput.sharedInstance()
        Brightness.sharedInstance()
        PowerStatus.sharedInstance()
        
        NotchManager.shared.refreshNotches()
    }
    
    @objc func openSettings() {
        openSettingsWindow()
    }
    
    @objc func quitApp() {
        if MewDefaultsManager.shared.hudEnabled {
            OSDUIManager.shared.start()
        }
        NSApplication.shared.terminate(self)
    }
    
    func applicationShouldTerminate(
        _ sender: NSApplication
    ) -> NSApplication.TerminateReply {
        if MewDefaultsManager.shared.hudEnabled {
            OSDUIManager.shared.start()
        }
        
        return .terminateNow
    }
}
