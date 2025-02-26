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
                    Picker(
                        "Mode",
                        selection: $defaultsManager.hudType,
                        content: {
                            ForEach(
                                MewDefaultsManager.HUDType.allCases
                            ) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                    )
                },
                header: {
                    Text("HUD")
                }
            )
        }
        .navigationTitle("General")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    GeneraSettingsView()
}
