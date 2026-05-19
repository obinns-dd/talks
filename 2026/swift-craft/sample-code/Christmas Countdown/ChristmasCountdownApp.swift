import SwiftUI
import SwiftData

@main
struct ChristmasCountdownApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List(SessionType.allCases) { type in
                    NavigationLink {
                        ContentView(session: type.createSession())
                    } label: {
                        Label(type.rawValue.capitalized, systemImage: type.icon)
                    }
                }.navigationTitle("Chats")
            }
        }
    }
}

