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
    
    @State private var isMenuShown: Bool = false
    
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
        Settings {
            NavigationSplitView(
                sidebar: {
                    Text("Something")
                },
                detail: {
                    Text("Detail Here")
                }
            )
        }
    }
}
