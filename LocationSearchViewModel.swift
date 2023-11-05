//
//  LocationSearchViewModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var searchResults = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    @Published var shouldRefocusOnUser: Bool = true

    private let searchCompleter: MKLocalSearchCompleter

    var searchFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = searchFragment
        }
    }

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self
    }

    func selectLocation(_ searchCompletion: MKLocalSearchCompletion) {
        performLocationSearch(with: searchCompletion.title) { [weak self] result in
            switch result {
            case .success(let coordinate):
                self?.selectedLocationCoordinate = coordinate
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func performLocationSearch(with query: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                completion(.success(coordinate))
            }
        }
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async { [weak self] in
            self?.searchResults = completer.results
        }
    }
}
