//
//  TrendView.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import SwiftUI
import WebKit

struct AttractionView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    let attraction: Attraction
    
    @State private var language: String = "en"
    @State private var urlString: String = "https://google.com"
    
    @State private var isLoading: Bool = false
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    
    let server_ip: String = "192.168.1.154"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("\(attraction.title)")
                    .bold()
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AsyncImage(url: attraction.image) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .clipShape(Rectangle())
                            .frame(height: 250)
                    case .failure(_):
                        Text("Failed to load image")
                    @unknown default:
                        Text("Unknown state")
                    }
                }
                .clipShape(Rectangle())
                .clipShape(.rect(cornerRadius: 20))
                
                Text("Description:")
                    .font(.system(size: 20))
                
                VStack(alignment: .leading) {
                    Text("\(attraction.description)")
                        .font(.system(size: 14))
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 20))
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Address:")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 5)
                        
                        Text("\(attraction.address)")
                            .font(.system(size: 12))
                    }
                    .padding()
                    .frame(width: 175, height: 100)
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 20))
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Distance:")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.bottom, 5)
                            .bold()
                        
                        Text("\(Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")) \(formatDistance(locationManager.calculateDistance(latitude: attraction.latitude, longitude: attraction.longitude)))")
                            .font(.system(size: 14))
                            .bold()
                    }
                    .padding()
                    .frame(width: 175, height: 100)
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 20))
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Phone:")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(attraction.phoneNumber)")
                            .font(.system(size: 14))
                    }
                    .padding()
                    .frame(width: 175, height: 70)
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 20))
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Schedule:")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text("\(attraction.schedule)")
                            .font(.system(size: 14))
                    }
                    .padding()
                    .frame(width: 175, height: 70)
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 20))
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 20) {
                    WebView(url: URL(string: urlString)!)
                        .frame(width: 350, height: 600)
                        .clipShape(.rect(cornerRadius: 20))
                    let url = "https://2gis.kz/\("astana")/geo/\(attraction.longitude)%2C\(attraction.latitude)"
                    
                    Link(destination: URL(string: url)!) {
                        Text("Open in 2GIS")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(.rect(cornerRadius: 20))
                    }
                }
                
                VStack {
                    Text("Yours AI Chat Bot")
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
                .frame(height: 700)
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 15))
            }
            
        }
        .padding()
        .onAppear {
            self.urlString = "https://2gis.kz/astana/directions/points/71.420026%2C51.166376%3B9570784863329619%7C71.438881%2C51.114367%3B9570784863367363?m=71.427345%2C51.140379%2F13.54"
            
//            self.urlString = "https://2gis.kz/\("astana")/geo/\(attraction.latitude)%2C\(attraction.longitude)"
            
            self.messages.append(Message(text: "You can ask me what you want about: \(attraction.title)", isUser: false))
        }
    }
    
    // MARK: POST request to the server
    func sendMessage() async {
        isLoading = true
        guard let url = URL(string: "http://\(server_ip):3000/attraction-question") else {
            isLoading = false
            return
        }
        
        
        let new_Message = Message(text: newMessage, isUser: true)
        messages.append(new_Message)
        
        let body: [String: String] = [
            "language": language,
            "request": newMessage,
            "title": attraction.title
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

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ChatBubble: View {
    var text: String
    var isUser: Bool
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
                Text(text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(text)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}



#Preview {
    AttractionView(attraction: Attraction(title: "Ethno-memorial complex «Atameken»", address: "Астана, Коргалжинское шоссе, 2/1", phoneNumber: "+7 (7172) 79-04-39", description: "The ethno-memorial complex “Map of Kazakhstan “Atameken” was opened on September 8, 2001 on the initiative of the first President of the Republic of Kazakhstan N. A. Nazarbayev. The founder of the enterprise is the mayor’s office of Astana. The authorized body of the enterprise is The Department of culture of the city of Astana.The objective of the Map of Kazakhstan “Atameken” is to ensure the safety, availability and involvement of population in historical, cultural and spiritual values, propaganda of achievements of the Kazakh culture, facilitating the study of historical heritage of Kazakhstan, a reflection of colorful all natural zones and economic achievements of the Republic of Kazakhstan, the preservation and enhancement of cultural values. Educational and artistic complex “Map of Kazakhstan “Atameken” will introduce You to the history of the state, the culture of its peoples.Stylized mountains, hills, steppes, forests, lakes, and symbolically designated major cities make up the symbolic ensemble of this cultural center. An interesting part of the Map of Kazakhstan “Atameken” is a decorative model of the Caspian sea.PRICELISTTour in Kazakh language – 200 tengeThe tour in Russian language – 200 tengeTour in English language – 500 tengePhotography – 300 tengeParticipants and invalids of the second world war-entrance is free and out of turn (upon presentation of supporting documents).Disabled people of group I, II and children with disabilities under 18 years of age-admission is free (upon presentation of supporting documents).Disabled people of group III-50% discount from the entrance ticket price (upon presentation of supporting documents).For orphans and children left without parental care who have not reached the age of 18-admission is free (upon presentation of supporting documents).Children under 5 (five) years old – free entrance (upon presentation of supporting documents).", schedule: "St-Sn: closed", image: URL(string: "https://astana.citypass.kz/wp-content/uploads/2018/07/atam2-624x405.jpg")!, link: URL(string: "https://astana.citypass.kz/en/2018/07/17/etno-memorialnyiy-kompleks-atameken/")!, latitude: 71.417785, longitude: 51.149358))
        .environmentObject(LocationManager())
}
