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
                        "Enabled",
                        isOn: $defaultsManager.hudEnabled
                    )
                    
                    Picker(
                        "Style",
                        selection: $defaultsManager.hudStyle,
                        content: {
                            ForEach(
                                MewDefaultsManager.HUDStyle.allCases
                            ) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                    )
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
