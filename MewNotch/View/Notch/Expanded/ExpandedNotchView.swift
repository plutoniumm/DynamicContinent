//
//  ExpandedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/03/25.
//

import SwiftUI

struct ExpandedNotchView: View {
    
    var namespace: Namespace.ID
    
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    @StateObject private var expandedNotchViewModel: ExpandedNotchViewModel = .init()
    
    var body: some View {
        if notchViewModel.isExpanded {
            VStack {
                HStack {
                    OnlyNotchView( notchSize: notchViewModel.notchSize )
                    PinControlView( notchViewModel: notchViewModel )
                }
                
                HStack( spacing: 12 ) {
                    let items = Array(
                        notchDefaults.expandedNotchItems.sorted {
                            $0.rawValue < $1.rawValue
                        }
                    )
                    
                    ForEach( 0..<items.count, id: \.self ) { index in
                        
                        let item = items[index]
                        
                        switch item {
                        case .Mirror:
                            MirrorView(
                                notchViewModel: notchViewModel
                            )
                        case .NowPlaying:
                          StatsDetailView()
                        }
                        
                        if index != items.count - 1 {
                            Divider()
                        }
                    }
                }
                .frame( height: notchViewModel.notchSize.height * 3 )
            }
            .padding(
                .init(
                    top: 0,
                    leading: 8 + notchViewModel.extraNotchPadSize.width / 2,
                    bottom: 8,
                    trailing: 8 + notchViewModel.extraNotchPadSize.width / 2
                )
            )
        }
    }
}
