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
    case muncipal = "muncipal"
    case plastic = "plastic"
    case glass = "glass"
    case bio = "bio"
    case pet_feces = "pet feces"
    case batteries = "batteries"
    var id: Self { self }
}

class TrashWizardViewModel: ObservableObject {
    @Published var trashType: TrashType = .none
    @Published var description: String = ""
    @Published var coordinates: String = ""
    @Published var location: String = ""
    
    private let imageClassificationService = ImageClassificationService()
    
    func getTrashTypeFromImageClassification(_ image: UIImage) -> TrashType {
        let prediction = imageClassificationService.classifyTrashImage(image: image)
        
        print("\(prediction)")
        print("\(TrashType(rawValue: prediction.classificationName))")

        guard let confidence = prediction.confidencePercentage, confidence >= 0.50 else {
            return TrashType.none
        }

        guard let trashType = TrashType(rawValue: prediction.classificationName) else {
            return TrashType.none
        }

        return trashType
    }
    
    func createTrash() {}
}
