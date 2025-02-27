//
//  MewSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct MewSettingsView: View {
    
    enum SettingsPages: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        
        case General
        
        case About
    }
    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    @State var selectedPage: SettingsPages = .General
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(
                    selection: $selectedPage
                ) {
                    ForEach(
                        SettingsPages.allCases
                    ) { page in
                        switch page {
                        case .General:
                            NavigationLink(
                                destination: {
                                    GeneraSettingsView()
                                }
                            ) {
                                Label(
                                    "General",
                                    systemImage: "gear"
                                )
                            }
                            .id(SettingsPages.General)
                        case .About:
                            NavigationLink(
                                destination: {
                                    AboutAppView()
                                }
                            ) {
                                Label(
                                    "About",
                                    systemImage: "info.circle"
                                )
                            }
                            .id(SettingsPages.About)
                        }
                    }
                }
            },
            detail: {
                GeneraSettingsView()
            }
        )
    }
}

#Preview {
    MewSettingsView()
}
