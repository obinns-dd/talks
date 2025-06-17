import FoundationModels
import Playgrounds

@Generable
struct PersonProfile {
    @Guide(description: "Proper name as displayed on official document")
    let name: String

    @Guide(.range(14...17))
    let age: Int
}

#Playground {
    let session = LanguageModelSession()

    let response = try await session.respond(
        to: "Hello, World!",
    )

    do {
        let person = try await session.respond(
            to: """
            A diverse list of ten people to use as placeholder content for App Store screenshots. \
            Include special unicode symbols and other edge-cases that may be useful for testing.
            """,
            generating: [PersonProfile].self
        )
    } catch {
        print("error: \(error)")
    }
}
