//
//  NotchSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI
import LaunchAtLogin

struct NotchSettingsView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var appDefaults = AppDefaults.shared
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @State var screens: [NSScreen] = []
    
    func refreshNSScreens() {
        withAnimation {
            self.screens = NSScreen.screens
        }
    }
    
    var body: some View {
        Form {
            Section(
                content: {
                    LaunchAtLogin.Toggle()
                    
                    Toggle( isOn: $appDefaults.showMenuIcon ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Status Icon")
                            
                            Text("Shown in Menu Bar for easy access")
                                .font(.footnote)
                        }
                    }
                },
                header: {
                    Text("App")
                }
            )
            
            Section(
                content: {
                    ForEach(
                        ExpandedNotchItem.allCases
                    ) { item in
                        Toggle(
                            isOn: .init(
                                get: { notchDefaults.expandedNotchItems.contains(item) },
                                set: { isEnabled in
                                    if isEnabled {
                                        notchDefaults.expandedNotchItems.insert(item)
                                    } else {
                                        notchDefaults.expandedNotchItems.remove(item)
                                    }
                                }
                            )
                        ) {
                            Text(item.displayName)
                        }
                    }
                },
                header: {
                    Text("Expanded Notch Items")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Notch")
        .toolbar {
            ToolbarItem( placement: .automatic ) {
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label("", systemImage: "power")
                }
            }
        }
        .onChange( of: notchDefaults.notchDisplayVisibility ) {
            NotchManager.shared.refreshNotches()
        }
        .onChange( of: notchDefaults.shownOnDisplay ) {
            NotchManager.shared.refreshNotches()
        }
        .onChange( of: scenePhase ) {
            self.refreshNSScreens()
        }
        .onAppear {
            self.refreshNSScreens()
        }
    }
}

#Preview {
    NotchSettingsView()
}
