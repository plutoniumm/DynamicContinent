//
//  NowPlayingMediaModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/03/25.
//

import SwiftUI

struct NowPlayingMediaModel {
    var appBundleIdentifier: String
    var appName: String
    var appIcon: Image
    
    var albumArt: Image
    
    var album: String
    var artist: String
    var title: String
    
    var elapsedTime: Double
    var totalDuration: Double
    
    var isPlaying: Bool
    
    var refreshedAt: Date = .now
    
    static var Placeholder: NowPlayingMediaModel {
        return .init(
            appBundleIdentifier: "<App Bundle Identifier Here>",
            appName: "<App Name Here>",
            appIcon: Image(systemName: "app.fill"),
            albumArt: Image(systemName: "square.fill"),
            album: "<Album Here>",
            artist: "<Artist Here>",
            title: "<Music Title Here>",
            elapsedTime: 0,
            totalDuration: 0,
            isPlaying: false
        )
    }
        
}
