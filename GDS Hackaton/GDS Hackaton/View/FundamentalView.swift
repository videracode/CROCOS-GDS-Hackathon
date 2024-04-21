////
////  Fundamental.swift
////  GDS Hackaton
////
////  Created by Abylaykhan Myrzakhanov on 21.04.2024.
////
//
//import SwiftUI
//
//
//struct FundamentalView: View {
//    @EnvironmentObject var locationManager: LocationManager
//    
//    @State private var currentState: ViewState = .first_acquitance
//    
//    @State private var userMessage: String = ""
//    
//    @State private var messages: [Message] = []
//    @State private var newMessage: String = ""
//    @State private var selectedLanguage: String = ""
//    
//    @State private var trends: [Attraction] = [Attraction]()
//    @State private var allTrends: [Attraction] = [Attraction]()
//    
//    @State private var isLoading: LoadingState = .none
//    
//    @State private var currentKeyboard: keyboardTypeCurrent = .none
//    
//    @State private var showError: Bool = false
//    @State private var errorMessage: String = ""
//    
//    let language = ["🇷🇺 RU", "🇺🇸 EN", "🇰🇿 KK"]
//    
//    enum ViewState: CaseIterable {
//        case first_acquitance
//        case chat
//        case trending
//    }
//    
//    enum LoadingState: CaseIterable {
//        case none
//        case language
//    }
//    
//    enum keyboardTypeCurrent: CaseIterable {
//        case none
//        case simple
//        case text_write
//    }
//    
//    let server_ip = "127.0.0.1"
//    
//    var body: some View {
//        Group {
//            VStack {
//                switch currentState {
//                case .first_acquitance:
//                    VStack(spacing: 40) {
//                        VStack(alignment: .leading) {
//                            ZStack(alignment: .center) {
//                                AsyncImage(url: URL(string: "https://astana.citypass.kz/wp-content/uploads/Group.jpg")) { phase in
//                                    switch phase {
//                                    case .empty:
//                                        ProgressView()
//                                    case .success(let image):
//                                        image
//                                            .resizable()
//                                            .clipShape(Rectangle())
//                                            .frame(maxWidth: .infinity, maxHeight: 200)
//                                            .overlay(alignment: .topTrailing) {
//                                                VStack(alignment: .trailing) {
//                                                    Text("Astana PASS")
//                                                        .font(.system(size: 16))
//                                                        .bold()
//                                                    Text("ОТ 7 990 ₸")
//                                                        .font(.system(size: 14))
//                                                        .bold()
//                                                }
//                                                .foregroundStyle(.white)
//                                                .padding()
//                                            }
//                                    case .failure(_):
//                                        Text("Failed to load image")
//                                    @unknown default:
//                                        Text("Unknown state")
//                                    }
//                                }
//                                .clipShape(Rectangle())
//                                .cornerRadius(20)
//                            }
//                            
//                            Text("Добро Пожаловать!")
//                                .font(.title)
//                                .bold()
//                                .monospaced()
//                            Text("Выберите язык.")
//                                .font(.title2)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
//                        VStack(spacing: 20) {
//                            ForEach(language, id:\.self) { lang in
//                                Button {
//                                    Task {
//                                        self.selectedLanguage = lang
//                                        await language_request()
//                                    }
//                                } label: {
//                                    Text("\(lang)")
//                                        .font(.system(size: 18))
//                                }
//                                .padding()
//                                .frame(width: 150)
//                                .background(.blue)
//                                .foregroundStyle(.white)
//                                .clipShape(.rect(cornerRadius: 25))
//                            }
//                        }
//                        Spacer()
//                    }
//                case .chat, .trending:
//                    VStack {
//                        ZStack {
//                            HStack {
//                                Text("\(Image(systemName: "point.bottomleft.filled.forward.to.point.topright.scurvepath")) ASTANA")
//                                    .foregroundColor(.white)
//                                    .bold()
//                                Spacer()
//                                Text("CityPASS")
//                                    .foregroundStyle(.white)
//                                    .bold()
//                            }
//                            .padding(.horizontal)
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: 50)
//                        .background(Color.blue)
//                        ScrollView(.vertical, showsIndicators: false) {
//                            ScrollViewReader { scrollView in
//                                VStack(spacing: 10) {
////                                    ForEach(messages, id: \.self) { message in
////                                        ChatBubble(text: message.text, isUser: message.isUser)
////                                    }
////                                    .onChange(of: messages) { _ in
////                                        scrollView.scrollTo(messages.last, anchor: .bottom)
////                                    }
//                                    
//                                    if !trends.isEmpty {
//                                        ScrollView(.horizontal, showsIndicators: false) {
//                                            LazyHStack(spacing: 10) {
//                                                ForEach(trends, id: \.title) { trend in
//                                                    VStack(alignment: .center) {
//                                                        Text("\(trend.title)")
//                                                            .bold()
//                                                            .font(.system(size: 12))
//                                                        
//                                                        AsyncImage(url: trend.image) { phase in
//                                                            switch phase {
//                                                            case .empty:
//                                                                ProgressView()
//                                                            case .success(let image):
//                                                                image
//                                                                    .resizable()
//                                                                    .clipShape(Rectangle())
//                                                                    .frame(maxWidth: 100, maxHeight: 100)
//                                                                    
//                                                            case .failure(_):
//                                                                Text("Failed to load image")
//                                                            @unknown default:
//                                                                Text("Unknown state")
//                                                            }
//                                                        }
//                                                        .clipShape(Rectangle())
//                                                        .cornerRadius(20)
//                                                        
//                                                        NavigationLink {
//                                                            
//                                                        } label: {
//                                                            Text("Подробнее")
//                                                                .foregroundStyle(.white)
//                                                        }
//                                                        .frame(width: 100, height: 30)
//                                                        .background(.blue)
//                                                        .clipShape(.rect(cornerRadius: 15))
//                                                        .font(.system(size: 10))
//                                                    }
//                                                    .frame(width: 175, height: 200)
//                                                    
//                                                    .background(.gray.opacity(0.1))
//                                                    .clipShape(.rect(cornerRadius: 15))
//                                                    
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                .padding()
//                            }
//                        }
//
//                        .overlay(alignment: .bottom) {
//                            VStack {
//                                switch currentKeyboard {
//                                case .text_write:
//                                    TextField("Введите сообщение", text: $userMessage)
//                                        .padding()
//                                        .background(Color.gray.opacity(0.1))
//                                        .cornerRadius(10)
//                                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                                        .foregroundColor(.black)
//                                        .font(.body)
//                                        .padding(.horizontal)
//                                        .padding(.bottom, 30)
//                                case .none:
//                                    VStack{}
//                                case .simple:
//                                    
//                                    HStack {
//                                        Button {
//                                            self.currentState = .trending
//                                            if currentState == .trending {
//                                                Task {
//                                                    await trends()
//                                                }
//                                            }
//                                        } label: {
//                                            Text("Yes")
//                                                .foregroundStyle(.blue)
//                                        }
//                                        Spacer()
//                                        Button {
//                                            
//                                        } label: {
//                                            Text("No")
//                                                .foregroundStyle(.red)
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color.gray.opacity(0.1))
//                                    .cornerRadius(10)
//                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                                    .foregroundColor(.black)
//                                    .font(.body)
//                                    .padding(.horizontal)
//                                    .padding(.bottom, 30)
//                                }
//                            }
//                        }
//                        .ignoresSafeArea()
//                        
//                    }
//                }
//            }
//        }
//    }
//    func language_request() async {
//        isLoading = .language
//        
//        guard let url = URL(string: "http://\(server_ip):3000/greeting") else {
//            presentError("Error while making request to the server")
//            isLoading = .none
//            return
//        }
//        
//        if selectedLanguage == language[0] {
//            selectedLanguage = "ru"
//        } else if selectedLanguage == language[1] {
//            selectedLanguage = "en"
//        } else {
//            selectedLanguage = "kk"
//        }
//        
//        let body = ["language": selectedLanguage]
//        a
//        do {
//            let finalBody = try JSONSerialization.data(withJSONObject: body)
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = finalBody
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            let semaphore = DispatchSemaphore(value: 0)
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                defer {
//                    semaphore.signal()
//                }
//                
//                if error != nil {
//                    presentError("Error while making request to the server")
//                    isLoading = .none
//                    return
//                }
//                
//                guard let data = data else {
//                    return
//                }
//                
//                if data != nil {
//                    do {
//                        let message = try JSONDecoder().decode([String: String].self, from: data)
//                        // Successfully decoded the JSON into a dictionary
//                        withAnimation {
//                            self.currentState = .chat
//                        }
//                        
//                        if let result = message["result"] {
//                            
//                            print("Decoded message:", result)
//                            self.messages.append(Message(text: result, isUser: false))
//                            
//                            
//                            Task {
//                                sleep(2)
//                                await trending_request()
//                            }
//                        } else {
//                            print("JSON data does not contain 'result' key")
//                        }
//                    } catch {
//                        // An error occurred while decoding JSON
//                        print("Error decoding JSON:", error)
//                    }
//                } else {
//                    // Data is nil
//                    print("Data is nil")
//                }
//                
//                
//                
//                isLoading = .none
//            }
//            .resume()
//            
//            await withCheckedContinuation { continuation in
//                DispatchQueue.global().async {
//                    semaphore.wait()
//                    continuation.resume()
//                }
//            }
//            
//        } catch {
//            presentError(error.localizedDescription)
//            isLoading = .none
//        }
//    }
//    
//    // Trending request
//    func trending_request() async {
//        isLoading = .language
//        
//        guard let url = URL(string: "http://\(server_ip):3000/trending-question") else {
//            presentError("Error while making request to the server")
//            isLoading = .none
//            return
//        }
//        
//        let body = ["language": selectedLanguage]
//        
//        do {
//            let finalBody = try JSONSerialization.data(withJSONObject: body)
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = finalBody
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            let semaphore = DispatchSemaphore(value: 0)
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                defer {
//                    semaphore.signal()
//                }
//                
//                if error != nil {
//                    presentError("Error while making request to the server")
//                    isLoading = .none
//                    return
//                }
//                
//                guard let data = data else {
//                    return
//                }
//                
//                if data != nil {
//                    do {
//                        let message = try JSONDecoder().decode([String: String].self, from: data)
//                        withAnimation {
//                            currentKeyboard = .simple
//                        }
//                        if let result = message["result"] {
//                            
//                            print("Decoded message:", result)
//                            self.messages.append(Message(text: result, isUser: false))
//                        } else {
//                            print("JSON data does not contain 'result' key")
//                        }
//                    } catch {
//                        // An error occurred while decoding JSON
//                        print("Error decoding JSON:", error)
//                    }
//                } else {
//                    // Data is nil
//                    print("Data is nil")
//                }
//                
//                isLoading = .none
//            }
//            .resume()
//            
//            await withCheckedContinuation { continuation in
//                DispatchQueue.global().async {
//                    semaphore.wait()
//                    continuation.resume()
//                }
//            }
//            
//        } catch {
//            //presentError(error.localizedDescription)
//            isLoading = .none
//        }
//    }
//    
//    // Presenting Error
//        func presentError(_ message: String) {
//            errorMessage = message
//            showError.toggle()
//        }
//    
//    // POST Trends
//    func trends() async {
//        isLoading = .language
//        
//        guard let url = URL(string: "http://\(server_ip):3000/trending") else {
//            presentError("Error while making request to the server")
//            isLoading = .none
//            return
//        }
//        
//        let body = ["language": selectedLanguage]
//        
//        do {
//            let finalBody = try JSONSerialization.data(withJSONObject: body)
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = finalBody
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            let semaphore = DispatchSemaphore(value: 0)
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                defer {
//                    semaphore.signal()
//                }
//                
//                if error != nil {
//                    presentError("Error while making request to the server")
//                    isLoading = .none
//                    return
//                }
//                
//                guard let data = data else {
//                    return
//                }
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                        let result = json["result"] as! [[String: Any]]
//                    for res in result {
//                        let trendData = try JSONSerialization.data(withJSONObject: res, options: [])
//                        let trend = try JSONDecoder().decode(Attraction.self, from: trendData)
//                        trends.append(trend)
//                    }
//                    
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//               
//                
//                isLoading = .none
//            }
//            .resume()
//            
//            await withCheckedContinuation { continuation in
//                DispatchQueue.global().async {
//                    semaphore.wait()
//                    continuation.resume()
//                }
//            }
//            
//        } catch {
//            presentError(error.localizedDescription)
//            isLoading = .none
//        }
//    }
//
//}
//
//#Preview {
//    FundamentalView()
//        .environmentObject(LocationManager())
//}
//
//struct ChatBubble: View {
//    let text: String
//    let isUser: Bool // Дополнительное свойство для определения отправителя
//    
//    var body: some View {
//        HStack {
//            if isUser {
//                Spacer()
//            }
//            Text(text)
//                .padding()
//                .foregroundColor(.white)
//                .background(isUser ? Color.blue : Color.gray)
//                .clipShape(ChatBubbleShape(isUser: isUser))
//            if !isUser {
//                Spacer()
//            }
//        }
//    }
//}
//
//
//struct ChatBubbleShape: Shape {
//    let isUser: Bool // Свойство для определения отправителя
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: isUser ? [.topLeft, .bottomLeft, .bottomRight] : [.topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
//        return Path(path.cgPath)
//    }
//}
