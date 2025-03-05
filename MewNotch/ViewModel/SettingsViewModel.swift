//
//  SettingsViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/03/2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var isLoadingLatestRelease: Bool = false
    
    @Published var didFailToLoadLatestRelease: Bool = false
    
    @Published var currentAppVersion: String
    @Published var latestRelease: MewReleaseAPIResponseModel?
    
    init() {
        self.currentAppVersion = Bundle.main.infoDictionary?[
            "CFBundleShortVersionString"
        ] as? String ?? ""
        
        self.refreshLatestRelease()
    }
    
    func refreshLatestRelease() {
        withAnimation {
            isLoadingLatestRelease = true
        }
        
        MewAPI.shared.getLatestRelease { latestRelease in
            withAnimation {
                self.didFailToLoadLatestRelease = latestRelease == nil
                
                self.latestRelease = latestRelease
                self.isLoadingLatestRelease = false
            }
        }
    }
}
