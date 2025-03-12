//
//  MinimalPowerHUDRightView.swift
//  MewNotch
//
//  Created by Monu Kumar on 12/03/25.
//

import SwiftUI

struct MinimalPowerHUDRightView: View {
    
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
                AnimatedTextView(
                    value: Double(hud.value * 100)
                ) { value in
                    Text(
                        String(
                            format: "%02.0f",
                            value
                        )
                    )
                    .font(.title3.bold())
                    .foregroundStyle(Color.white)
                }
            }
            .padding(
                .trailing,
                notchViewModel.extraNotchPadSize.width / 2
            )
            .transition(
                .offset(
                    x: -notchViewModel.extraNotchPadSize.width / 2
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
