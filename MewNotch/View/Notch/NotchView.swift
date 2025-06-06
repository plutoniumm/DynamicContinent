//
//  NotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

struct NotchView: View {
  @Environment(\.openSettings) private var openSettings
  @StateObject var notchViewModel: NotchViewModel

  init( screen: NSScreen ) {
    self._notchViewModel = .init(
      wrappedValue: .init(
        screen: screen
      )
    )
  }

  var body: some View {
    VStack {
      HStack {
        Spacer()

        ZStack( alignment: .top ) {
          ExpandedNotchView( notchViewModel: notchViewModel )
          CollapsedNotchView( notchViewModel: notchViewModel )
        }
        .background {
          Color.black
        }
        .mask {
          NotchShape(
            topRadius: notchViewModel.cornerRadius.top,
            bottomRadius: notchViewModel.cornerRadius.bottom
          )
        }
        .scaleEffect(
          notchViewModel.isHovered ? 1.05 : 1.0,
          anchor: .top
        )
        .shadow(
          radius: notchViewModel.isHovered ? 5 : 0
        )
        .onHover {
          notchViewModel.onHover(
            $0,
            shouldExpand: true
          )
        }
        .onTapGesture( perform: notchViewModel.onTap )

        Spacer()
      }

      Spacer()
    }
    .preferredColorScheme(.dark)
    .contextMenu(
      menuItems: {

        Button("Fix System HUD") {
          OSDUIManager.shared.reset()
        }

        Button("Settings") {
          openSettings()
        }
        .keyboardShortcut( ",", modifiers: .command )

        Button("Restart") {
          AppManager.shared.restartApp( killPreviousInstance: true )
        }
        .keyboardShortcut("R", modifiers: .command)
      }
    )
  }
}
