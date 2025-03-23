//
//  MewNotchApp.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI
import SwiftData

@main
struct MewNotchApp: App {
    
    @NSApplicationDelegateAdaptor(MewAppDelegate.self) var mewAppDelegate
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings
    
    @StateObject private var appDefaults = AppDefaults.shared
    
    @State private var isMenuShown: Bool = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError(
                "Could not create ModelContainer: \(error)"
            )
        }
    }()

    var body: some Scene {
        MenuBarExtra(
            isInserted: $isMenuShown,
            content: {
                Text("MewNotch")
                
                Button("Settings") {
                    openSettings()
                }
                .keyboardShortcut(
                    ",",
                    modifiers: .command
                )

                
                Button("Restart") {
                    guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
                        return
                    }
                    
                    let workspace = NSWorkspace.shared
                    
                    if let appURL = workspace.urlForApplication(
                        withBundleIdentifier: bundleIdentifier
                    ) {
                        let configuration = NSWorkspace.OpenConfiguration()
                        
                        configuration.createsNewApplicationInstance = true
                        
                        workspace.openApplication(
                            at: appURL,
                            configuration: configuration
                        )
                    }
                
                   NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("R", modifiers: .command)
                
                Button(
                    "Quit",
                    role: .destructive
                ) {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut(
                    "Q",
                    modifiers: .command
                )
            }
        ) {
            MewNotch.Assets.iconMenuBar
                .renderingMode(.template)
        }
        .onChange(
            of: appDefaults.showMenuIcon
        ) { oldVal, newVal in
            if oldVal != newVal {
                isMenuShown = newVal
            }
        }
        
        Settings {
            MewSettingsView()
                .modelContainer(sharedModelContainer)
        }
    }
}
