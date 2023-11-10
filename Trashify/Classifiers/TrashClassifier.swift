//
//  TrashifyClassifier.swift
//  Trashify
//
//  Created by Kacper Bylicki on 26/10/2023.
//
import Vision
import UIKit

/// `TrashClassifier` is responsible for predicting the type of trash based on the given image.
class TrashClassifier {
    
    // Singleton instance of the CoreML model for trash classification.
    private static let imageClassifier = createImageClassifier()

    /// Creates and returns an instance of the CoreML model for trash classification.
    private static func createImageClassifier() -> VNCoreMLModel {
        let defaultConfig = MLModelConfiguration()
        
        guard let imageClassifierWrapper = try? TrashImageClassificationModel(configuration: defaultConfig),
              let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierWrapper.model) else {
            fatalError("Failed to create the model instance")
        }
        
        return imageClassifierVisionModel
    }
    
    // Dictionary to map each Vision request to its corresponding completion handler.
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    
    // Holds the results of the trash classification.
    private var trashPredictionResults: [TrashClass]? = nil
    
    // Publicly accessible prediction result.
    var trashPrediction = TrashClass(classificationName: "")

    /// Initiates the trash classification process for a given image.
    /// - Parameter image: The image to be classified.
    func classifyTrash(_ image: UIImage) {
        do {
            try makePredictions(for: image, completionHandler: trashPredictionHandler)
        } catch {
            print("Error making prediction: \(error.localizedDescription)")
        }
    }

    /// Creates a prediction request for the provided image and invokes Vision to classify it.
    private func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = photo.cgImagePropertyOrientation
        
        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }

        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        try handler.perform([imageClassificationRequest])
    }

    /// Creates and returns a VNCoreMLRequest for image classification.
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        let request = VNCoreMLRequest(model: TrashClassifier.imageClassifier, completionHandler: visionRequestHandler)
        request.imageCropAndScaleOption = .centerCrop
        return request
    }

    /// Handles the results from the Vision request, extracting and processing the classification results.
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }

        defer {
            predictionHandler(trashPredictionResults)
        }

        if let error = error {
            print("Vision classification error: \(error.localizedDescription)")
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            print("Incorrect result type from VNRequest.")
            return
        }

        trashPredictionResults = observations.map { observation in
            TrashClass(classificationName: observation.identifier, confidencePercentage: observation.confidence)
        }
    }

    /// Processes and stores the classification results.
    private func trashPredictionHandler(_ predictions: [TrashClass]?) {
        guard let predictions = predictions else {
            print("No Prediction")
            return
        }
        trashPrediction = predictions.first!
    }
}

extension UIImage {
    /// Converts `UIImage.Orientation` to `CGImagePropertyOrientation` for use with Vision requests.
    var cgImagePropertyOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        default: return .up
        }
    }
}

/// Represents a classification result with the name of the trash type and its confidence level.
struct TrashClass {
    let classificationName: String
    let confidencePercentage: Float?

    init(classificationName: String, confidencePercentage: Float? = nil) {
        self.classificationName = classificationName
        self.confidencePercentage = confidencePercentage
    }
}

/// Type definition for a callback function that processes classification results.
typealias ImagePredictionHandler = (_ predictions: [TrashClass]?) -> Void

