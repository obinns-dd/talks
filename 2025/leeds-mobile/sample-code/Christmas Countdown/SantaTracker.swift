import Foundation
import FoundationModels

struct PersonTracker: Tool {
    let name = "Santa Tracker"
    let description = "Retrieve Santa's current location and departure time"

    @Generable
    struct Arguments {
        @Generable
        enum Person {
            case santa
        }

        @Guide(description: "The person to search for")
        var person: Person
    }

    func call(arguments: Arguments) async throws -> ToolOutput {
        // Perform any relevant API calls or other work here:
        let response = GeneratedContent(properties: [
            "location" : "Leeds",
            "takeOffTime" : 1766570379251
        ])

        return ToolOutput(response)
    }
}

