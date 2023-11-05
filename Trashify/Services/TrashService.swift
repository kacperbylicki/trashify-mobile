//
//  TrashService.swift
//  Trashify
//
//  Created by Kacper Bylicki on 04/11/2023.
//

import Foundation

struct TrashInDistanceRequest: Codable {
    let latitude: Float
    let longitude: Float
    let minDistance: Int?
    let maxDistance: Int?
}

struct TrashInDistance: Decodable, Equatable {
    let uuid: String
    let geolocation: [Float]
    let tag: String
}

struct TrashInDistanceResponse: Decodable {
    let status: Int
    let trash: [TrashInDistance]?
    let error: String?
}

enum ServiceError: Error {
    case urlError
    case serverError(String)
    case decodingError(Error)
    case unknownError
    case customError(String)
}

class TrashService {
    private let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""

    func fetchTrashInDistance(accessToken: String, request: TrashInDistanceRequest) async throws -> [TrashInDistance] {
        do {
            let urlRequest = try createURLRequest(accessToken: accessToken, request: request)
            let (trashData, _) = try await URLSession.shared.data(for: urlRequest)
            let trashResponse = try JSONDecoder().decode(TrashInDistanceResponse.self, from: trashData)

            if trashResponse.status != 200 {
                throw ServiceError.serverError(trashResponse.error ?? "Server responded with status code: \(trashResponse.status)")
            }

            guard let trashItems = trashResponse.trash else {
                throw ServiceError.unknownError
            }

            return trashItems
        } catch let error as ServiceError {
            throw error
        } catch {
            throw ServiceError.decodingError(error)
        }
    }

    private func createURLRequest(accessToken: String, request: TrashInDistanceRequest) throws -> URLRequest {        
        var urlComponents = URLComponents(string: "\(baseURL)/trash/distance")
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: "\(request.latitude)"),
            URLQueryItem(name: "longitude", value: "\(request.longitude)")
        ]

        if let minDistance = request.minDistance {
            urlComponents?.queryItems?.append(URLQueryItem(name: "minDistance", value: "\(minDistance)"))
        }
        if let maxDistance = request.maxDistance {
            urlComponents?.queryItems?.append(URLQueryItem(name: "maxDistance", value: "\(maxDistance)"))
        }

        guard let url = urlComponents?.url else {
            throw ServiceError.urlError
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

