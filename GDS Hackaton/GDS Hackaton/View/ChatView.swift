//
//  ChatView.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    
    @State private var isLoading: Bool = false
    
    let server_ip: String = "192.168.1.154"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text("Astana Chat Bot")
                    .font(.system(size: 20))
                    .bold()
                    .monospaced()
                    .padding(.vertical)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(text: message.text, isUser: message.isUser)
                        }
                    }
                }
                
                HStack {
                    TextField("Введите сообщение", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        Task {
                            await sendMessage()
                        }
                    } label: {
                        Text("Отправить")
                    }
                }
                .padding()
            }
            .padding()
            .frame(minHeight: 700)
            
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 15))
        }
    }
    
    // MARK: Sending POST request
    func sendMessage() async {
        isLoading = true
        guard let url = URL(string: "http://\(server_ip):3000/astana-bot") else {
            isLoading = false
            return
        }
        
        
        let new_Message = Message(text: newMessage, isUser: true)
        messages.append(new_Message)
        
        let body: [String: String] = [
            "request": newMessage,
        ]
        
        newMessage = ""
        
        do {
            let finalBody = try JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let message = try JSONDecoder().decode([String: String].self, from: data)
            
            if let result = message["result"] {
                self.messages.append(Message(text: result, isUser: false))
            } else {
                print("JSON data does not contain 'result' key")
            }
            
        } catch {
            print("Error:", error.localizedDescription)
            isLoading = false
        }
    }
}

#Preview {
    ChatView()
}
