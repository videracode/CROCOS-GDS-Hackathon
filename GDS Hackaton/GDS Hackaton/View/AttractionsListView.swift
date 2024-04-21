//
//  AttractionsView.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import SwiftUI

struct AttractionsListView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var language: String = "en"
    
    @State private var popular: [Attraction] = [Attraction]()
    @State private var allAttractions: [Attraction] = [Attraction]()
    
    @State private var isPopularLoading: Bool = false
    @State private var isAllLoading: Bool = false
    
    let server_ip: String = "192.168.1.154"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text("Popular")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.vertical)
                
                if isPopularLoading {
                    ProgressView()
                } else {
                    ForEach(popular, id:\.title) { popular in
                        TrendCard(attraction: popular)
                            .padding(.top, 5)
                    }
                }
            }
            
            VStack {
                Text("Attractions")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.vertical)
                
                if isAllLoading {
                    ProgressView()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(allAttractions, id: \.title) { attraction in
                            BasicCard(attraction: attraction)
                                .environmentObject(locationManager)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if popular.isEmpty {
                Task {
                    await getPopular()
                    await getAll()
                }
            }
        }
    }
    
    // MARK: POST request for get Popular
    func getPopular() async {
        isPopularLoading = true
        
        guard let url = URL(string: "http://\(server_ip):3000/trending") else {
            isPopularLoading = false
            return
        }
        
        let body = ["language": language]
        
        do {
            let finalBody = try JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let semaphore = DispatchSemaphore(value: 0)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer {
                    semaphore.signal()
                }
                
                if error != nil {
                    isPopularLoading = false
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let result = json["result"] as! [[String: Any]]
                    for res in result {
                        let trendData = try JSONSerialization.data(withJSONObject: res, options: [])
                        let trend = try JSONDecoder().decode(Attraction.self, from: trendData)
                        popular.append(trend)
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                
                isPopularLoading = false
            }
            .resume()
            
            await withCheckedContinuation { continuation in
                DispatchQueue.global().async {
                    semaphore.wait()
                    continuation.resume()
                }
            }
            
        } catch {
            print(error.localizedDescription)
            isPopularLoading = false
        }
    }
    
    // MARK: POST request for get All Attractions
    func getAll() async {
        isAllLoading = true
        
        guard let url = URL(string: "http://\(server_ip):3000/attractions-all") else {
            isAllLoading = false
            return
        }
        
        let body = ["language": language]
        
        do {
            let finalBody = try JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let semaphore = DispatchSemaphore(value: 0)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer {
                    semaphore.signal()
                }
                
                if error != nil {
                    isAllLoading = false
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let result = json["result"] as! [[String: Any]]
                    for res in result {
                        let trendData = try JSONSerialization.data(withJSONObject: res, options: [])
                        let attraction = try JSONDecoder().decode(Attraction.self, from: trendData)
                        allAttractions.append(attraction)
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                
                isAllLoading = false
            }
            .resume()
            
            await withCheckedContinuation { continuation in
                DispatchQueue.global().async {
                    semaphore.wait()
                    continuation.resume()
                }
            }
            
        } catch {
            print(error.localizedDescription)
            isAllLoading = false
        }
    }
}

#Preview {
    AttractionsListView()
        .environmentObject(LocationManager())
}

struct BasicCard: View {
    @EnvironmentObject var locationManager: LocationManager
    
    let attraction: Attraction
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(attraction.title)")
                .bold()
                .font(.system(size: 12))
            
            AsyncImage(url: attraction.image) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .clipShape(Rectangle())
                        .frame(width: 130, height: 100)
                case .failure(_):
                    Text("Failed to load image")
                @unknown default:
                    Text("Unknown state")
                }
            }
            .clipShape(Rectangle())
            .clipShape(.rect(cornerRadius: 15))
            
            NavigationLink {
                AttractionView(attraction: attraction)
                    .environmentObject(locationManager)
            } label: {
                Text("Info")
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: 70)
            .frame(height: 40)
            .background(.blue)
            .clipShape(.rect(cornerRadius: 15))
        }
        .frame(width: 170, height: 225)
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 15))
    }
}


struct TrendCard: View {
    @EnvironmentObject var locationManager: LocationManager
    
    let attraction: Attraction
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 20) {
            Text("\(attraction.title)")
                .font(.system(size: 20))
                .padding(.horizontal)
            
            AsyncImage(url: attraction.image) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .clipShape(Rectangle())
                        .frame(maxWidth: .infinity, maxHeight: 200)
                case .failure(_):
                    Text("Failed to load image")
                @unknown default:
                    Text("Unknown state")
                }
            }
            .clipShape(Rectangle())
            .cornerRadius(20)
                
            HStack {
                VStack(alignment: .leading) {
                    Text("Distance")
                        .bold()
                        .font(.system(size: 16))

                    Text("\(Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")) \(formatDistance(locationManager.calculateDistance(latitude: attraction.latitude, longitude: attraction.longitude)))")
                        .font(.system(size: 14))
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink {
                    AttractionView(attraction: attraction)
                        .environmentObject(locationManager)
                } label: {
                    Text("More info")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: 150)
                .frame(height: 50)
                .background(.blue)
                .clipShape(.rect(cornerRadius: 15))
            }
        }
        .padding()
        .background(.gray.opacity(0.2))
        .clipShape(.rect(cornerRadius: 15))
    }
}
