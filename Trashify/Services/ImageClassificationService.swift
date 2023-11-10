//
//  ImageClassificationService.swift
//  Trashify
//
//  Created by Kacper Bylicki on 24/10/2023.
//
import Foundation
import UIKit

enum ImageClassificationError: Error, LocalizedError {
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        }
    }
}

class ImageClassificationService {
    let trashClassifier = TrashClassifier()
    
    var detectedTrash = TrashClass(classificationName: "")
    
    func classifyTrashImage(image: UIImage) -> TrashClass {
        self.trashClassifier.classifyTrash(image)
        detectedTrash = trashClassifier.trashPrediction
        
        return detectedTrash
    }
}
