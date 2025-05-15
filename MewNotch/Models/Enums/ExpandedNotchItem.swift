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

    case HackerNews
    case Stats

    var displayName: String {
        switch self {
        case .HackerNews:
            return "HackerNews"
        case .Stats:
            return "Now Playing"
        }
    }
}
