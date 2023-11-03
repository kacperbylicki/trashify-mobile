//
//  LocationSearchViewModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    @Published var shouldRefocusOnUser: Bool = true
    @Published var userLocation: CLLocationCoordinate2D?
    
    @Published var trashItems: [TrashInDistance] = []
    @Published var error: String? = nil
    
    private let trashService = TrashService()
    private let authService = AuthenticationService()
    private var keychainHelper = KeychainHelper()
    
    // Load the access token from the keychain
    private var accessToken: String {
        keychainHelper.load("accessToken") ?? ""
    }

    private let searchCompleter = MKLocalSearchCompleter()

    var searchFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = searchFragment
        }
    }

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = searchFragment
    }

    func selectLocation(_ searchCompletion: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: searchCompletion) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let item = response?.mapItems.first else {
                return
            }

            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
            self.fetchTrashInDistance(latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude), minDistance: 0, maxDistance: 1500)
        }
    }
    
    func fetchTrashInDistance(latitude: Float, longitude: Float, minDistance: Int? = nil, maxDistance: Int? = nil) {
        Task {
            do {
                print("ok")
                let fetchedItems = try await trashService.fetchTrashInDistance(accessToken: accessToken, latitude: latitude, longitude: longitude, minDistance: minDistance, maxDistance: maxDistance)
                
                DispatchQueue.main.async {
                    self.trashItems = fetchedItems
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = (error as? AuthenticationError)?.localizedDescription ?? "Unknown Error"
                }
            }
        }
    }

    func locationSearch(forLocalSearchCompletion searchCompletion: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchCompletion.title

        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }


}

extension LocationSearchViewModel {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
