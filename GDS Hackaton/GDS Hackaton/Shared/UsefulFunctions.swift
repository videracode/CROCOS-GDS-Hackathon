//
//  UsefulFunctions.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import SwiftUI

func formatDistance(_ distance: Double) -> String {
    if distance >= 1000 {
        let kilometers = distance / 1000
        return String(format: "%.1f km", kilometers)
    } else {
        return "\(Int(distance)) m"
    }
}

func openAnotherApp(url: String) {
    guard let appUrl = URL(string: url) else { return }
    if UIApplication.shared.canOpenURL(appUrl) {
        UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
    }
}
