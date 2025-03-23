//
//  HUDMediaSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDMediaSettingsView: View {
    
    @StateObject var mediaDefaults = HUDMediaDefaults.shared
    
    var body: some View {
        Form {
            Section(
                content: {
                    Toggle(
                        isOn: $mediaDefaults.isEnabled
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Enabled")
                            
                            Text("Shows media playing app with animation")
                                .font(.footnote)
                        }
                    }
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Media")
    }
}

#Preview {
    HUDMediaSettingsView()
}
