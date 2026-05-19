protocol LanguageSession {
    var contextWindowUsed: Int { get }
    var isTyping: Bool { get }
    var messages: [Message] { get }
    
    func sendMessage(_ message: String) async throws
}
