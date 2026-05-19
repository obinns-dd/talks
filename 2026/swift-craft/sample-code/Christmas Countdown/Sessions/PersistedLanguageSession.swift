import Foundation
import FoundationModels
import Observation

@Observable
final class PersistedLanguageSession: LanguageSession {
    private(set) var isTyping = false
    private(set) var contextWindowUsed: Int = 0

    private var session: LanguageModelSession = {
        LanguageModelSession()
    }()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private(set) var messages: [Message] {
        didSet {
            Task {
                self.contextWindowUsed = try await SystemLanguageModel.default.tokenCount(for: session.transcript)
            }
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: .transcript),
           let transcript = try? decoder.decode(Transcript.self, from: data) {
            session = LanguageModelSession(transcript: transcript)
            messages = transcript.compactMap { entry in
                switch entry {
                case .prompt(let prompt):
                    return Message(
                        id: entry.id,
                        content: prompt.segments[0].description,
                        sender: .me
                    )
                case .response(let response):
                    return Message(
                        id: entry.id,
                        content: response.segments[0].description,
                        sender: .other
                    )
                default: return nil
                }
            }
        } else {
            session = LanguageModelSession(
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
            messages = []
        }

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
        if let transcript = try? encoder.encode(session.transcript) {
            UserDefaults.standard.set(transcript, forKey: .transcript)
        }

        messages.append(
            Message(id: UUID().uuidString, content: response.content, sender: .other)
        )
    }
}

extension String {
    fileprivate static var transcript: String {
        "transcript"
    }
}
