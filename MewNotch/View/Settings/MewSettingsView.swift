//
//  MewSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct MewSettingsView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    enum SettingsPages: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        
        case General
        case Notch
        
        case Brightness
        
        case Audio
//        case AudioOutput
//        case AudioInput
        
        case Media
        case Power
        
        case About
    }
    
    @StateObject var settingsViewModel: SettingsViewModel = .init()
    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    @State var selectedPage: SettingsPages = .General
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(
                    selection: $selectedPage
                ) {
                    Section(
                        content: {                            
                            NavigationLink(
                                destination: {
                                    NotchSettingsView()
                                }
                            ) {
                                Label(
                                    title: {
                                        Text("Notch")
                                    },
                                    icon: {
                                        MewNotch.Assets.iconMenuBar
                                            .renderingMode(.template)
                                    }
                                )
                            }
                            .id(SettingsPages.Notch)
                        }
                    )   
                }
            },
            detail: {
              NotchSettingsView()
            }
        )
        .onChange(
            of: scenePhase
        ) {
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
