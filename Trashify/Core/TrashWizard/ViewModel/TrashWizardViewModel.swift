//
//  TrashWizardViewModel.swift
//  Trashify
//
//  Created by Kacper Bylicki on 26/10/2023.
//

import SwiftUI

struct CustomTrashWizardError: Error {
    var errorMessage: String
}

enum TrashWizardError: LocalizedError {
    case invalidImageBuffer
    case trashCreationError(String)
    case imageClassificationError(String)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidImageBuffer:
            return "Invalid image buffer"
        case .trashCreationError(let error):
            return error
        case .imageClassificationError(let error):
            return error
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

enum TrashType: String, CaseIterable, Identifiable {
    case none = ""
    case municipal = "municipal"
    case plastic = "plastic"
    case glass = "glass"
    case bio = "bio"
    case pet_feces = "pet feces"
    case batteries = "batteries"
    var id: Self { self }
}

class TrashWizardViewModel: ObservableObject {
    @Published var trashType: TrashType = .none
    @Published var coordinates: [Double] = []
    @Published var location: String = ""
    
    private var keychainHelper = KeychainHelper()
    private let imageClassificationService = ImageClassificationService()
    private let trashService = TrashService()
    
    private var accessToken: String {
        keychainHelper.load("accessToken") ?? ""
    }
    
    func getTrashTypeFromImageClassification(_ image: UIImage) -> TrashType {
        let prediction = imageClassificationService.classifyTrashImage(image: image)

        guard let confidence = prediction.confidencePercentage, confidence >= 0.50 else {
            return TrashType.none
        }

        guard let trashType = TrashType(rawValue: prediction.classificationName) else {
            return TrashType.none
        }

        return trashType
    }
    
    func createTrash() async throws {
            // Creating the request object
            let createRequest = CreateTrashRequest(trash: TrashDetail(geolocation: coordinates, tag: trashType.rawValue))

            do {
                // Making the API call through TrashService
                let status = try await trashService.createTrash(accessToken: accessToken, request: createRequest)

                // Handle the response based on the status code
                if status != 201 {
                    throw TrashWizardError.trashCreationError("Failed to create trash: Server returned status \(status)")
                }
            } catch let error as ServiceError {
                // Custom error handling for ServiceError
                print(error)
                throw TrashWizardError.trashCreationError("Service error: \(error.localizedDescription)")
            } catch {
                // General error handling
                throw TrashWizardError.unknownError(error)
            }
        }
}
