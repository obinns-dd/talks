import Foundation
import SwiftData

@Observable
final class Message: Identifiable {
    let id: String
    var content: String
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

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

enum Sender: Codable {
    case me
    case other
}
