//
//  NotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class NotchViewModel: ObservableObject {
    
    var screen: NSScreen
    
    @Published var notchSize: CGSize = .zero
    
    var extraNotchPadSize: CGSize = .init(
        width: 14,
        height: 0
    )
    
    init(
        screen: NSScreen
    ) {
        self.screen = screen
        
        self.notchSize = NotchUtils.shared.notchSize(
            screen: self.screen,
            force: NotchDefaults.shared.forceEnabled
        )
        
        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height
        }
    }
    
    func refreshNotchSize() {
        self.notchSize = NotchUtils.shared.notchSize(
            screen: self.screen,
            force: NotchDefaults.shared.forceEnabled
        )
        
        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height
        }
    }
}
