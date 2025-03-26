//
//  NowPlayingHUDLeftView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

struct NowPlayingHUDLeftView: View {
    
    var namespace: Namespace.ID = Namespace().wrappedValue
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var nowPlayingModel: NowPlayingMediaModel?
    
    var body: some View {
        if let nowPlayingModel {
            nowPlayingModel.albumArt
                .resizable()
                .aspectRatio(
                    1,
                    contentMode: .fit
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                )
                .matchedGeometryEffect(
                    id: "NowPlayingAlbumArt",
                    in: namespace
                )
                .padding(4)
                .frame(
                    width: notchViewModel.notchSize.height,
                    height: notchViewModel.notchSize.height
                )
                .padding(
                    .init(
                        top: 0,
                        leading: notchViewModel.extraNotchPadSize.width / 2,
                        bottom: 0,
                        trailing: -notchViewModel.extraNotchPadSize.width / 2
                    )
                )
        }
    }
}
