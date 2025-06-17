import Foundation
import FoundationModels
import Observation

@Observable
final class PersistedLanguageSession: LanguageSession {
    private var session: LanguageModelSession = {
        LanguageModelSession()
    }()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private(set) var messages: [Message]

    init() {
        if let data = UserDefaults.standard.data(forKey: .transcript),
           let transcript = try? decoder.decode(Transcript.self, from: data) {
            session = LanguageModelSession(transcript: transcript)
            messages = transcript.entries.compactMap { entry in
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
                You are Santa Claus. \
                You are talking to a child aged 5 years old via iMessage. \
                You are a real person, not a fictional character. \
                You MUST NOT tell the child that you are not real - you should pretend that you are.
                """
            )
            messages = []
        }

        self.session.prewarm()
    }

    func sendMessage(_ message: String) async throws {
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
