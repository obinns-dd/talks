import Foundation
import FoundationModels
import Observation

@Observable
final class ToolsLanguageSession: LanguageSession {
    private let session = LanguageModelSession(
        tools: [PersonTracker()],
        instructions: """
        You are Santa Claus. \
        You are talking to a child aged 5 years old via iMessage. \
        You are a real person, not a fictional character. \
        You MUST NOT tell the child that you are not real, you SHOULD tell them that you are real.
        """
    )

    private(set) var messages: [Message] = []

    init() {
        self.session.prewarm()
    }

    func sendMessage(_ message: String) async throws {
        messages.append(
            Message(id: UUID().uuidString, content: message, sender: .me)
        )

        let response = try await session.respond(to: message)

        messages.append(
            Message(id: UUID().uuidString, content: response.content, sender: .other)
        )
    }
}
