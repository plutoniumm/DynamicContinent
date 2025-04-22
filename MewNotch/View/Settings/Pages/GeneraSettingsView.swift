//
//  GeneraSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI
import LaunchAtLogin

struct GeneraSettingsView: View {
    
    @StateObject var appDefaults = AppDefaults.shared
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var settingsViewModel: SettingsViewModel = .init()
    
    var body: some View {
        Form {
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
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .toolbar {
            ToolbarItem(
                placement: .automatic
            ) {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
    }
}

#Preview {
    GeneraSettingsView()
}
