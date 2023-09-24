//
//  LocationManager.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation? = nil {
        didSet {
            fetchAddress(for: location)
        }
    }
    @Published var placemark: CLPlacemark? = nil

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    private func fetchAddress(for location: CLLocation?) {
        guard let location = location else { return }

        geocoder.reverseGeocodeLocation(location) { placemark, error in
            if let error = error {
                print("Could not geocode location: \(error.localizedDescription)")
                return
            }

            self.placemark = placemark?.first
        }
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
}
