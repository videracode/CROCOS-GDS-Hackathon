//
//  LocationManager.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import SwiftUI
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    @Published var city: String?
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func calculateDistance(latitude: Double, longitude: Double) -> Double {
        let currentLocation = CLLocation(latitude: location?.coordinate.latitude ?? 0, longitude: location?.coordinate.longitude ?? 0)
        let targetLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distance = currentLocation.distance(from: targetLocation) / 1000
        return distance
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let geocoder = CLGeocoder()
        let preferredLocale = NSLocale(localeIdentifier: "en")
        geocoder.reverseGeocodeLocation(location, preferredLocale: preferredLocale as Locale) { placemarks, error in
            if error != nil {
                self.city = ""
                return
            }
            if let placemarks = placemarks?.first {
                if let cityName = placemarks.locality {
                    self.city = cityName
                }
            }
        }
    }
}
