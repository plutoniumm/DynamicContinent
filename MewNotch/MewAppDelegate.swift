//
//  MewAppDelegate.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

import MediaKeyTap

class MewAppDelegate: NSObject, NSApplicationDelegate {
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.openSettings) var openSettingsWindow
    
    var windows: [NSScreen: NSWindow] = [:]
    
    var window: NSWindow!
    
    var mediaKeyTap: MediaKeyTap?
    
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
        
        mediaKeyTap = MediaKeyTap(
            delegate: self
        )
        
        mediaKeyTap?.start()
        
        guard let screen = NSScreen.main else { return }
        
        var panel: NSWindow! = windows[screen]
        
        if panel == nil {
            let view: NSView = NSHostingView(
                rootView: NotchView()
            )
            
            panel = MewPanel(
                contentRect: .zero,
                styleMask: [
                    .borderless,
                    .nonactivatingPanel
                ],
                backing: .buffered,
                defer: true
            )
            
            panel.contentView = view
            
            panel.orderFrontRegardless()
            
            panel.setFrame(
                screen.frame,
                display: true
            )
            
            self.windows[screen] = panel
            NotchSpaceManager.shared.notchSpace.windows.insert(panel)
        }
        
//        self.createStatusItem()
    }
    
    func createStatusItem() {
        let statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.squareLength
        )
        
        let menu = NSMenu()
        
        menu.items = [
            NSMenuItem(
                title: "Settings",
                action: #selector(openSettings),
                keyEquivalent: "S"
            ),
            NSMenuItem(
                title: "Quit",
                action: #selector(quitApp),
                keyEquivalent: "Q"
            ),
        ]
        
//        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image = NSImage(
                named: "Speaker"
            )
            button.image?.isTemplate = true
            
            button.identifier = NSUserInterfaceItemIdentifier("MewStatusItem")
        }
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

extension MewAppDelegate: MediaKeyTapDelegate {
    
    func handle(
        mediaKey: MediaKey,
        event: KeyEvent?,
        modifiers: NSEvent.ModifierFlags?
    ) {
//        print(mediaKey)
        switch mediaKey {
        case .volumeUp, .volumeDown, .mute:
            NotificationManager.shared.postVolumeChanged()
        case .brightnessDown, .brightnessUp:
            NotificationManager.shared.postBrightnessChanged()
        case .keyboardBrightnessUp, .keyboardBrightnessDown, .keyboardBrightnessToggle:
            NotificationManager.shared.postBacklightChanged()
        default:
            return
        }
    }
}
