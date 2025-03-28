//
//  NotchSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct NotchSettingsView: View {
    
    @StateObject var notchDefaults = NotchDefaults.shared
    
    var body: some View {
        Form {
            Section(
                content: {
                    Toggle(
                        isOn: $notchDefaults.forceEnabled
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Force Enable")
                            
                            Text("Enable Notch on Non-notched Displays")
                                .font(.footnote)
                        }
                    }
                    
                    Picker(
                        selection: $notchDefaults.heightMode,
                        content: {
                            Text(
                                NotchHeightMode.Match_Notch.rawValue.replacingOccurrences(
                                    of: "_",
                                    with: " "
                                )
                            )
                            .tag(
                                NotchHeightMode.Match_Notch
                            )
                            
                            Text(
                                NotchHeightMode.Match_Menu_Bar.rawValue.replacingOccurrences(
                                    of: "_",
                                    with: " "
                                )
                            )
                            .tag(
                                NotchHeightMode.Match_Menu_Bar
                            )
                        }
                    ) {
                        Text("Height")
                    }
                },
                header: {
                    Text("Interface")
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
                        }
                    }
                },
                header: {
                    Text("Interaction")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Notch")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotchSettingsView()
}
