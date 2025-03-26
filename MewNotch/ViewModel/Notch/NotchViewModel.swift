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
        width: 16,
        height: 0
    )
    
    @Published var isHovered: Bool = false
    @Published var isExpanded: Bool = false
    
    private var hoverTimer: Timer? = nil
    
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
    
    func onHover(_ isHovered: Bool) {
        hoverTimer?.invalidate()
        
        if isHovered {
            hoverTimer = .scheduledTimer(
                withTimeInterval: 0.7,
                repeats: false
            ) { _ in
                self.onTap()
            }
        } else {
            withAnimation {
                self.isExpanded = false
            }
        }
        
        withAnimation {
            self.isHovered = isHovered
        }
    }
    
    func onTap() {
        withAnimation(
            .spring(
                .bouncy(
                    duration: 0.5,
                    extraBounce: 0.1
                )
            )
        ) {
            self.isExpanded = true
        }
    }
}
