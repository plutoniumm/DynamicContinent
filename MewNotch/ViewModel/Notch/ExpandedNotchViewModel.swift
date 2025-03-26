//
//  ExpandedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class ExpandedNotchViewModel: ObservableObject {
    
    @Published var nowPlayingMedia: NowPlayingMediaModel?
    
    init() {
        self.startListeners()
    }
    
    deinit {
        self.stopListeners()
    }
    
    func startListeners() {
        // MARK: Media Change Listeners
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingInfo,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingState,
            object: nil
        )
    }
    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNowPlayingMediaChanges() {
        guard let appBundleIdentifier = NowPlaying.sharedInstance().appBundleIdentifier,
        let appName = NowPlaying.sharedInstance().appName,
        let appIcon = NowPlaying.sharedInstance().appIcon,
        let albumArt = NowPlaying.sharedInstance().albumArt,
        let album = NowPlaying.sharedInstance().album,
        let artist = NowPlaying.sharedInstance().artist,
        let title = NowPlaying.sharedInstance().title else {
            if NowPlaying.sharedInstance().playing {
                NowPlaying.sharedInstance().updateInfo()
            }
            return
        }
        
        withAnimation {
            nowPlayingMedia = .init(
                appBundleIdentifier: appBundleIdentifier,
                appName: appName,
                appIcon: .init(
                    nsImage: appIcon
                ),
                albumArt: .init(
                    nsImage: albumArt
                ),
                album: album,
                artist: artist,
                title: title,
                isPlaying: NowPlaying.sharedInstance().playing
            )
        }
    }
    
}
