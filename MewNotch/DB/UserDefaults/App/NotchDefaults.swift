import Foundation
import DotEnv

class NotchDefaults: ObservableObject {

    private static var PREFIX: String = "Notch_"

    static let shared = NotchDefaults()

    private init() {
      try? DotEnv.load(path: ".env");
    }

    var Bahamut_auth: String = ProcessInfo.processInfo.environment["BAHAMUT_AUTH"] ?? ""

    @CodableUserDefault(
        PREFIX + "NotchDisplayVisibility",
        defaultValue: NotchDisplayVisibility.NotchedDisplayOnly
    )
    var notchDisplayVisibility: NotchDisplayVisibility {
        didSet {
            self.objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "ShownOnDisplay",
        defaultValue: [:]
    )
    var shownOnDisplay: [String: Bool] {
        didSet {
            self.objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "HeightMode",
        defaultValue: NotchHeightMode.Match_Menu_Bar
    )
    var heightMode: NotchHeightMode {
        didSet {
            self.objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "ExpandedNotchItems",
        defaultValue: [
            ExpandedNotchItem.HackerNews
        ]
    )
    var expandedNotchItems: Set<ExpandedNotchItem> {
        didSet {
            self.objectWillChange.send()
        }
    }
}
