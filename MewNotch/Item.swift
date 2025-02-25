//
//  Item.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
