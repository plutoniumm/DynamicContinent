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
    
    var album: String
    var artist: String
    var title: String
    
    var isPlaying: Bool
}
