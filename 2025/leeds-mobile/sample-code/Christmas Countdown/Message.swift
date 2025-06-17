import Foundation
import SwiftData

final class Message: Identifiable {
    let id: String
    let content: String
    let sender: Sender

    init(
        id: String,
        content: String,
        sender: Sender,
    ) {
        self.id = id
        self.content = content
        self.sender = sender
    }
}

enum Sender: Codable {
    case me
    case other
}
