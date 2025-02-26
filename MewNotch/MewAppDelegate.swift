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
        OSDUIManager.shared.stop()
        
        mediaKeyTap = MediaKeyTap(
            delegate: self
        )
        
        mediaKeyTap?.start()
        
        guard let screen = NSScreen.main else { return }
        
        let view: NSView = NSHostingView(
            rootView: NotchView()
        )
        
        let panel = MewPanel(
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
        
        NotchSpaceManager.shared.notchSpace.windows.insert(panel)
        
//        self.createStatusItem()
    }
    
    func createStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        let menu = NSMenu()
        
        menu.items = [
            NSMenuItem(
                title: "Quit App",
                action: #selector(quitApp),
                keyEquivalent: "Q"
            ),
        ]
        
        item.menu = menu
        
        item.isVisible = true
        
        if let button = item.button {
//            button.image = NSImage(named: "muse")
            button.image = NSStatusBarButton.init(checkboxWithTitle: "", target: nil, action: nil).image
            button.image?.isTemplate = true
            
            button.identifier = NSUserInterfaceItemIdentifier("MewStatusItem")
        }
    }
    
    @objc func openSettings() {
        
    }
    
    @objc func quitApp() {
        OSDUIManager.shared.start()
        NSApplication.shared.terminate(self)
    }
    
    func applicationShouldTerminate(
        _ sender: NSApplication
    ) -> NSApplication.TerminateReply {
        OSDUIManager.shared.start()
        
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
