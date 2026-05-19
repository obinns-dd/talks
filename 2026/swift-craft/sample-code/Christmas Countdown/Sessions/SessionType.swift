enum SessionType: String, Identifiable, CaseIterable {
    case basic
    case persisted
    case streaming
    case tools
    case noSafety = "No Safety"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .basic:
            return "text.bubble"
        case .persisted:
            return "square.and.arrow.down"
        case .streaming:
            return "rectangle.and.pencil.and.ellipsis"
        case .tools:
            return "wrench.and.screwdriver"
        case .noSafety:
            return "shield.lefthalf.filled.slash"
        }
    }

    func createSession() -> LanguageSession {
        switch self {
        case .basic: return BasicLanguageSession()
        case .persisted: return PersistedLanguageSession()
        case .streaming: return StreamingLanguageSession()
        case .tools: return ToolsLanguageSession()
        case .noSafety: return NoSafetyLanguageSession()
        }
    }
}
