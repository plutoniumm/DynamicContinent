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
                        "HUD Enabled",
                        isOn: $defaultsManager.hudEnabled
                    )
                    
                    Picker(
                        "HUD Mode",
                        selection: $defaultsManager.hudType,
                        content: {
                            ForEach(
                                MewDefaultsManager.HUDType.allCases
                            ) { type in
                                Text(type.rawValue.capitalized)
                                    .tag(type)
                            }
                        }
                    )
                    .disabled(!defaultsManager.hudEnabled)
                },
                header: {
                    Text("Closed State")
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
