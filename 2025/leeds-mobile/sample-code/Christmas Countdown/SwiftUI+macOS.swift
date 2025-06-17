import SwiftUI

extension Color {
    static var systemGray5: Self {
        #if canImport(UIKit)
        return Color(.systemGray5)
        #else
        return Color(.systemGray)
        #endif
    }
}

extension ToolbarItemPlacement {
    @available(macOS 26.0, *)
    static var toolbar: Self {
        #if canImport(UIKit)
        return .bottomBar
        #else
        return .automatic
        #endif
    }
}
