//
//  MinimalPowerHUDLeftView.swift
//  MewNotch
//
//  Created by Monu Kumar on 12/03/25.
//

import SwiftUI

struct MinimalPowerHUDLeftView: View {
    
    @ObservedObject var notchViewModel: CollapsedNotchViewModel
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let hud = hudModel {
            Text(
                "000%"
            )
            .font(.title3.bold())
            .frame(
                height: notchViewModel.notchSize.height
            )
            .opacity(0)
            .overlay {
                hud
                    .getIcon()
                    .padding(8)
            }
            .padding(
                .leading,
                notchViewModel.extraNotchPadSize.width / 2
            )
            .transition(
                .offset(
                    x: notchViewModel.extraNotchPadSize.width / 2
                )
                .combined(
                    with: .opacity
                )
            )
        }
    }
}

#Preview {
    MinimalPowerHUDLeftView(
        notchViewModel: .init(
            screen: .main!
        )
    )
}
