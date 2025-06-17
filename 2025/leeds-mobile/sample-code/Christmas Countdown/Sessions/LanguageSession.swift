protocol LanguageSession {
    var messages: [Message] { get }
    
    func sendMessage(_ message: String) async throws
}
