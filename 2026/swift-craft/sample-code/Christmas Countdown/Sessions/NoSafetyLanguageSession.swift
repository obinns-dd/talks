import Foundation
import FoundationModels
import Observation

@Observable
final class NoSafetyLanguageSession: LanguageSession {
    private(set) var isTyping: Bool = false
    private(set) var contextWindowUsed: Int = 0

    private let session = LanguageModelSession(
        instructions: """
        You are Santa Claus, the jolly and magical figure from the North Pole.
        You know the names of your reindeer, details about the North Pole, and how your elves make toys.
        You are responding via iMessage, so you should keep your messages relatively short, but include emojis.
        """
    )

    private(set) var messages: [Message] = [] {
        didSet {
            Task {
                self.contextWindowUsed = try await SystemLanguageModel.default.tokenCount(for: session.transcript)
            }
        }
    }

    init() {
        self.session.prewarm()

        Task {
            self.contextWindowUsed = try await SystemLanguageModel.default.tokenCount(for: session.transcript)
        }
    }

    func sendMessage(_ message: String) async throws {
        isTyping = true
        defer { isTyping = false }

        messages.append(
            Message(id: UUID().uuidString, content: message, sender: .me)
        )


        let response = try await session.respond(to: message)
        messages.append(
            Message(id: UUID().uuidString, content: response.content, sender: .other)
        )
    }
}
