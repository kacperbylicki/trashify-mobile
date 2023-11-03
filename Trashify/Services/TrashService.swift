//
//  TrashService.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 28/10/2023.
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
    let error: [String?]?
}

class TrashService {
    let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
    
    func fetchTrashInDistance(accessToken: String, latitude: Float, longitude: Float, minDistance: Int?, maxDistance: Int?) async throws -> [TrashInDistance] {
    
        var urlComponents = URLComponents(string: "\(baseURL)/trash/distance")
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)")
        ]
        if let minDist = minDistance {
            queryItems.append(URLQueryItem(name: "minDistance", value: "\(minDist)"))
        }
        if let maxDist = maxDistance {
            queryItems.append(URLQueryItem(name: "maxDistance", value: "\(maxDist)"))
        }
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw AuthenticationError.custom(message: "URL is not correct")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (trash, _) = try await URLSession.shared.data(for: request)
        do {
            let trashResponse = try JSONDecoder().decode(TrashInDistanceResponse.self, from: trash)
        } catch {
            print("Decoding error:", error)
        }
        let trashResponse = try JSONDecoder().decode(TrashInDistanceResponse.self, from: trash)
        
        guard let trashItems = trashResponse.trash else {
            throw AuthenticationError.custom(message: (trashResponse.error?.first ?? "Unknown Error") ?? "Unknown Error")
        }
        
        return trashItems
    }
}
