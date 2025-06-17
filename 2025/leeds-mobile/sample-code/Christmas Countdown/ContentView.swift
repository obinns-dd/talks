import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var newMessage: String = ""
    @FocusState private var messageFieldIsFocussed: Bool

    private let session: LanguageSession = ToolsLanguageSession()

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack {
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

                            if item.sender != .me {
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .onTapGesture {
                    messageFieldIsFocussed = false
                }
            }
            .defaultScrollAnchor(.bottom)
            .toolbar {
                ToolbarItem(placement: .toolbar) {
                    TextField("Type a message...", text: $newMessage)
                        .focused($messageFieldIsFocussed)
                        .padding()
                }

                ToolbarItem(placement: .toolbar) {
                    Button(action: addItem) {
                        Label(
                            "Send",
                            systemImage: "paperplane.fill"
                        )
                    }
                    .disabled(newMessage.isEmpty)
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            sendMessage(newMessage)
            newMessage = ""
        }
    }

    private func sendMessage(_ message: String) {
        Task.detached {
            do {
                try await session.sendMessage(message)
            } catch {
                print("error with message: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
