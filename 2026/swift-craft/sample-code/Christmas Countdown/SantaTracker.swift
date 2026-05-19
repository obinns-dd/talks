import Foundation
import FoundationModels

struct SantaTracker: Tool {
    let name = "Santa Tracker"
    let description = "Retrieve your (Santa's) current location and departure time"

    @Generable
    struct Arguments {
        @Generable
        enum Person {
            case santa
        }

        @Guide(description: "The person to search for")
        var person: Person
    }

    func call(arguments: Arguments) async throws -> String {
        "Santa is in Leeds, UK. He took off at 12pm local time"
    }
}
