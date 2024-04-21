//
//  Trend.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import Foundation

struct Attraction: Hashable, Decodable {
    let title: String
    let address: String
    let phoneNumber: String
    let description: String
    let schedule: String
    let image: URL
    let link: URL
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case address = "Address"
        case phoneNumber = "Phone Number"
        case description = "Description"
        case schedule = "Schedule"
        case image = "Image"
        case link = "Link"
        case latitude = "Latitude"
        case longitude = "Longtitude"
    }
}
