//
//  GeneraSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct GeneraSettingsView: View {
    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    var body: some View {
        Form {
            Section(
                content: {
                    Toggle(
                        isOn: $defaultsManager.showMenuIcon
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
                        isOn: $defaultsManager.notchForceEnabled
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
                        selection: $defaultsManager.notchHeightMode,
                        content: {
                            Text(
                                MewDefaultsManager.NotchHeightMode.Match_Notch.rawValue.replacingOccurrences(
                                    of: "_",
                                    with: " "
                                )
                            )
                            .tag(
                                MewDefaultsManager.NotchHeightMode.Match_Notch
                            )
                            
                            Text(
                                MewDefaultsManager.NotchHeightMode.Match_Menu_Bar.rawValue.replacingOccurrences(
                                    of: "_",
                                    with: " "
                                )
                            )
                            .tag(
                                MewDefaultsManager.NotchHeightMode.Match_Menu_Bar
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
            
            Section(
                content: {
                    Toggle(
                        isOn: $defaultsManager.hudEnabled
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Enabled")
                            
                            Text("Show Volume and Brightness changes on Notch and turn off system HUD")
                                .font(.footnote)
                        }
                    }
                    
                    Picker(
                        selection: $defaultsManager.hudStyle,
                        content: {
                            ForEach(
                                MewDefaultsManager.HUDStyle.allCases
                            ) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Style")
                            
                            Text("Design to be used for HUD")
                                .font(.footnote)
                        }
                    }
                    .disabled(!defaultsManager.hudEnabled)
                },
                header: {
                    Text("HUD")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    GeneraSettingsView()
}
