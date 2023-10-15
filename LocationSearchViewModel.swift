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
