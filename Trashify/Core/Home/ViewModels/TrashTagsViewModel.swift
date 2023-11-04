//
//  TrashTagsViewModel.swift
//  Trashify
//
//  Created by Kacper Bylicki on 04/11/2023.
//

import CoreLocation

struct TrashTag: Identifiable {
    let id: UUID
    let title: String
    let coordinate: CLLocationCoordinate2D
}

enum ViewModelError: Error {
    case serviceError(String)
    case unknownError
    case customError(String)
}

@MainActor
class TrashTagsViewModel: ObservableObject {
    @Published var trashTags: [TrashTag] = []
    private let trashService = TrashService()
    private var keychainHelper = KeychainHelper()
    
    private var accessToken: String {
        keychainHelper.load("accessToken") ?? ""
    }

    func fetchTrashTags(center: CLLocationCoordinate2D) async {
        do {
            let request = GetTrashInDistanceRequest(
                latitude: Float(center.latitude),
                longitude: Float(center.longitude),
                minDistance: 5,
                maxDistance: 1500
            )
            
            let trashInDistance = try await trashService.fetchTrashInDistance(
                accessToken: accessToken,
                request: request
            )

            trashTags = trashInDistance.map { item in
                TrashTag(
                    id: UUID(uuidString: item.uuid) ?? UUID(),
                    title: item.tag,
                    coordinate: CLLocationCoordinate2D(
                        latitude: CLLocationDegrees(item.geolocation[1]),
                        longitude: CLLocationDegrees(item.geolocation[0])
                    )
                )
            }
        } catch let error as ServiceError {
            switch error {
            case .serverError(let message):
                print("Server error: \(message)")
            case .urlError:
                print("URL error")
            case .decodingError(let decodeError):
                print("Decoding error: \(decodeError)")
            case .unknownError:
                print("Unknown error")
            case .customError(let customMessage):
                print("Error: \(customMessage)")
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}


