import FoundationModels
import Playgrounds

#Playground {
    let session = LanguageModelSession()

    let stream = try await session.streamResponse(
        to: "Write an original joke about Swift programming.",
    )

    for try await partial in stream {
        print(partial)
    }
}
