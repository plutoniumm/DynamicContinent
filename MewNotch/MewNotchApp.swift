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

    init() {
        self._isMenuShown = .init( initialValue: true )
    }

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
                    AppManager.shared.restartApp(
                        killPreviousInstance: true
                    )
                }
                .keyboardShortcut("R", modifiers: .command)
            }
        ) {
            MewNotch.Assets.iconMenuBar
                .renderingMode(.template)
        }

        Settings {
            MewSettingsView()
                .modelContainer(sharedModelContainer)
        }
    }
}
