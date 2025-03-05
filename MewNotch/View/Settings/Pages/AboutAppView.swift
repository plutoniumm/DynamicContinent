//
//  AboutAppView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct AboutAppView: View {
    
    @Environment(\.openURL) private var openURL
    
    @ObservedObject var settingsViewModel: SettingsViewModel = .init()
    
    var body: some View {
        Form {
            Section(
                content: {
                    HStack {
                        Text("Version")
                        
                        Spacer()
                        
                        Text(settingsViewModel.currentAppVersion)
                    }
                },
                header: {
                    Text("App")
                }
            )
            
            Section(
                content: {
                    if let latestRelease = settingsViewModel.latestRelease {
                        HStack {
                            Text("Version")
                            
                            Spacer()
                            
                            Text(latestRelease.tagName)
                                .bold()
                        }
                        
                        if let publishedAt = latestRelease.publishedAt {
                            HStack {
                                Text("Released At")
                                
                                Spacer()
                                
                                Text(
                                    publishedAt.formatted(
                                        format: "dd MMM yyyy, hh:mm a"
                                    )
                                )
                                .bold()
                            }
                        }
                        
                        HStack {
                            Text("Download")
                            
                            Spacer()
                            
                            ForEach(
                                latestRelease.assets,
                                id: \.name
                            ) { asset in
                                if let url = URL(
                                    string: asset.browserDownloadUrl
                                ) {
                                    Button(
                                        asset.name,
                                        action: {
                                            openURL(url)
                                        }
                                    )
                                }
                            }
                        }
                        
                        if let url = URL(
                            string: "https://github.com/monuk7735/mew-notch"
                        ) {
                            HStack {
                                Text("Source Code")
                                
                                Spacer()
                                
                                Button(
                                    "View on Github",
                                    action: {
                                        openURL(url)
                                    }
                                )
                            }
                        }
                    } else if settingsViewModel.didFailToLoadLatestRelease {
                        Text("Failed to Load")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.red)
                    }
                },
                header: {
                    HStack {
                        Text("Latest Release")
                        
                        Spacer()
                        
                        if settingsViewModel.isLoadingLatestRelease {
                            Text("000")
                                .opacity(0)
                                .overlay {
                                    ProgressView()
                                        .scaleEffect(0.5)
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .leading
                                        )
                                }
                        }
                        
                        Button(
                            "Check for Updates",
                            action: settingsViewModel.refreshLatestRelease
                        )
                        .disabled(settingsViewModel.isLoadingLatestRelease)
                    }
                }
            )
        }
        .formStyle(
            .grouped
        )
        .navigationTitle("About")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutAppView()
}
