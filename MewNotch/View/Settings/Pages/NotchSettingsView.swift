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
                    Picker(
                        selection: $notchDefaults.notchDisplayVisibility,
                        content: {
                            ForEach(
                                NotchDisplayVisibility.allCases
                            ) { item in
                                Text(item.displayName)
                                .tag(item)
                            }
                        }
                    ) {
                        Text("Show Notch On")
                    }
                    
                    if notchDefaults.notchDisplayVisibility == .Custom {
                        VStack {
                            HStack {
                                Text("Choose Displays to show notch on")
                                Spacer()
                                Button(
                                    action: {
                                        self.refreshNSScreens()
                                    }
                                ) {
                                    Text("Refresh List")
                                }
                            }
                            
                            HStack {
                                ScrollView(
                                    .horizontal
                                ) {
                                    LazyHStack(
                                        spacing: 16
                                    ) {
                                        ForEach(
                                            self.screens,
                                            id: \.self
                                        ) { screen in
                                            Text(
                                                screen.localizedName
                                            )
                                            .padding(16)
                                            .frame(
                                                minHeight: 100
                                            )
                                            .background {
                                                if notchDefaults.shownOnDisplay[screen.localizedName] == true {
                                                    Color.gray.opacity(0.5)
                                                } else {
                                                    Color.gray.opacity(0.1)
                                                }
                                            }
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 16
                                                )
                                            )
                                            .onTapGesture {
                                                let oldValue = notchDefaults.shownOnDisplay[screen.localizedName] ?? false
                                                
                                                withAnimation {
                                                    notchDefaults.shownOnDisplay[screen.localizedName] = !oldValue
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                header: {
                    Text("Displays")
                }
            )
          
            Section(
                content: {
                    LaunchAtLogin.Toggle()
                    
                    Toggle(
                        isOn: $appDefaults.showMenuIcon
                    ) {
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
                    Toggle(
                        isOn: $notchDefaults.expandOnHover
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Expand on Hover")
                            
                            Text("Expand notch when hovered for more than 500ms.\nDisables click interactions in all HUDs")
                                .font(.footnote)
                        }
                    }
                },
                header: {
                    Text("Interaction")
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
        .toolbarTitleDisplayMode(.inline)
        .onChange(
            of: notchDefaults.notchDisplayVisibility
        ) {
            NotchManager.shared.refreshNotches()
        }
        .onChange(
            of: notchDefaults.shownOnDisplay
        ) {
            NotchManager.shared.refreshNotches()
        }
        .onChange(
            of: scenePhase
        ) {
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
