import FoundationModels
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var newMessage: String = ""
    @FocusState private var messageFieldIsFocussed: Bool

    @State private var session: LanguageSession

    @State private var typingAnimation: Bool = false

    private var contextWindowSize: Int {
        SystemLanguageModel.default.contextSize
    }

    init(session: LanguageSession) {
        self.session = session
    }

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(session.messages) { item in
                        HStack {
                            if item.sender == .me {
                                Spacer()
                            }

                            Text(item.content)
                                .font(.body)
                                .padding(12)
                                .background(item.sender == .me ? .blue : .systemGray5)
                                .foregroundStyle(item.sender == .me ? .white : .black)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous))
                                .id(item.id)
                                .animation(.spring, value: item.content)

                            if item.sender != .me {
                                Spacer()
                            }
                        }
                    }.onChange(of: session.messages) { oldValue, newValue in
                        withAnimation {
                            value.scrollTo(newValue.last?.id)
                        }
                    }

                    if session.isTyping {
                        HStack {
                            Image(systemName: "ellipsis")
                                .symbolEffect(.pulse, value: typingAnimation)
                                .font(.body)
                                .padding(12)
                                .background(Color.systemGray5)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous))
                                .onAppear { typingAnimation.toggle() }

                            Spacer()
                        }
                    }
                }.padding()
            }
            .scrollClipDisabled(true)
            .onTapGesture {
                messageFieldIsFocussed = false
            }

            VStack {
                Text("Currently used \(session.contextWindowUsed) of \(contextWindowSize) context window")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                HStack {
                    TextField("Type a message...", text: $newMessage)
                        .focused($messageFieldIsFocussed)
                    
                    Button(action: addItem) {
                        Label(
                            "Send",
                            systemImage: "paperplane.fill"
                        ).labelStyle(.iconOnly)
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16.0))
            }
            .padding()
        }
    }

    private func addItem() {
        withAnimation {
            sendMessage(newMessage)
            newMessage = ""
        }
    }

    private func sendMessage(_ message: String) {
        Task {
            do {
                try await session.sendMessage(message)
            } catch {
                print("error with message: \(error)")
            }
        }
    }
}

#Preview {
    ContentView(session: BasicLanguageSession())
}
