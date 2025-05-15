//
//  MewSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct MewSettingsView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NotchSettingsView()
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate()
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: NSApplication.willResignActiveNotification
                )
            ) { _ in
                NSApp.setActivationPolicy(.accessory)
                NSApp.deactivate()
            }
            .task {
                guard let window = NSApp.windows.first(
                    where: {
                        $0.identifier?.rawValue == "com_apple_SwiftUI_Settings_window"
                    }
                ) else {
                    return
                }
                
                window.toolbarStyle = .unified
                window.styleMask.insert(.resizable)
            }
    }
}

#Preview {
    MewSettingsView()
}
