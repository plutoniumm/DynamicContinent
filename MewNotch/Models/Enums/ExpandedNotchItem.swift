//
//  ExpandedNotchItem.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//


enum ExpandedNotchItem: String, CaseIterable, Codable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case Mirror
    case NowPlaying
    
    var displayName: String {
        switch self {
        case .Mirror:
            return "HackerNews"
        case .NowPlaying:
            return "Now Playing"
        }
    }
}
