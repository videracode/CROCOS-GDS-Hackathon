//
//  ContentView.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager: LocationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            TabView {
                AttractionsListView()
                    .environmentObject(locationManager)
                    .tabItem {
                        Label(
                            title: { Text("Attractions") },
                            icon: { Image(systemName: "house") }
                        )
                    }
                    .tag(0)
                ChatView()
                    .tabItem {
                        Label(
                            title: { Text("Astana-Chat") },
                            icon: { Image(systemName: "house") }
                        )
                    }
                    .tag(1)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}
