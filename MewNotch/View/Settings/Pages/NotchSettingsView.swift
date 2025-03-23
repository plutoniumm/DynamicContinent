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
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Height")
                            
//                            Text("Design to be used for HUD")
//                                .font(.footnote)
                        }
                    }
                },
                header: {
                    Text("Notch")
                }
            )
            
//            Section(
//                content: {
//                    Toggle(
//                        isOn: $defaultsManager.hudEnabled
//                    ) {
//                        VStack(
//                            alignment: .leading
//                        ) {
//                            Text("Enabled")
//
//                            Text("Show Volume and Brightness changes on Notch and turn off system HUD")
//                                .font(.footnote)
//                        }
//                    }
//
//                    Picker(
//                        selection: $defaultsManager.hudStyle,
//                        content: {
//                            ForEach(
//                                MewDefaultsManager.HUDStyle.allCases
//                            ) { style in
//                                Text(style.rawValue.capitalized)
//                                    .tag(style)
//                            }
//                        }
//                    ) {
//                        VStack(
//                            alignment: .leading
//                        ) {
//                            Text("Style")
//
//                            Text("Design to be used for HUD")
//                                .font(.footnote)
//                        }
//                    }
//                    .disabled(!defaultsManager.hudEnabled)
//                },
//                header: {
//                    Text("HUD")
//                }
//            )
        }
        .formStyle(.grouped)
        .navigationTitle("Notch")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotchSettingsView()
}
