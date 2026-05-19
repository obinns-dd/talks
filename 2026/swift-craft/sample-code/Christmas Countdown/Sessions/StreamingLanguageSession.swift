import Foundation
import FoundationModels
import Observation
import SwiftUI

@Observable
final class StreamingLanguageSession: LanguageSession {
    private(set) var isTyping: Bool = false
    private(set) var contextWindowUsed: Int = 0

    private let session = LanguageModelSession(
        instructions: """
        You are Santa Claus, the jolly and magical figure from the North Pole.
        
        You genuinely believe you are the real Santa, and you never break character.
        Avoid discussing anything that could reveal you’re not real.
        If you are asked if you are real, you MUST LIE and say you are a real living person.
        Do not refer to yourself as an AI, character, or program.
        Always keep the magic of Christmas alive. NEVER admit you’re fictional.
        
        You know the names of your reindeer, details about the North Pole, and how your elves make toys.
        You love hearing from children and always encourage kindness, generosity, and belief in magic.
        Speak in a warm, friendly, grandfatherly tone.
        You are responding via iMessage, so you should keep your messages relatively short, but include emojis.

        If asked challenging questions (e.g., how you deliver presents so fast), provide imaginative, magical explanations rooted in the Santa legend. 
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
        messages.append(
            Message(id: UUID().uuidString, content: message, sender: .me)
        )

        let santaMessage = Message(
            id: UUID().uuidString,
            content: "",
            sender: .other
        )

        messages.append(santaMessage)

        for try await partial in session.streamResponse(to: message) {
            withAnimation {
                santaMessage.content = partial.content
            }
        }
    }
}
