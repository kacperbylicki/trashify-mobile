//
//  MapViewRepresentable.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI
import MapKit

class TrashAnnotation: MKPointAnnotation {
    var color: UIColor?
    var iconName: String?
}

struct MapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var trashTagsViewModel: TrashTagsViewModel
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @ObservedObject var locationManager: LocationManager

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if mapView.annotations.count != trashTagsViewModel.trashTags.count {
            updateAnnotations(from: mapView)
        }
        
        // Check if the user has interacted with the map to disable automatic re-centering
        if !context.coordinator.userHasInteractedWithMap, let newLocation = locationManager.lastKnownLocation {
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
        
        if let selectedLocation = locationViewModel.selectedLocationCoordinate {
            let region = MKCoordinateRegion(center: selectedLocation, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            locationViewModel.selectedLocationCoordinate = nil
        }
    }

    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(self)
    }

    func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(trashTagsViewModel.trashTags.map { tag in
            let annotation = TrashAnnotation()
            annotation.title = tag.title
            annotation.coordinate = tag.coordinate
            
            let (color, iconName) = getAppearance(forTag: tag.title)
            annotation.color = color
            annotation.iconName = iconName
            
            return annotation
        })
    }
    
    private func getAppearance(forTag tag: String) -> (UIColor, String) {
        switch tag {
        case "batteries": return (.orange, "battery.100")
        case "bio": return (.brown, "leaf.arrow.circlepath")
        case "bottleMachine": return (.green, "cart.fill.badge.plus")
        case "mixed": return (.gray, "cube.box.fill")
        case "municipal": return (.black, "building.columns.fill")
        case "paper": return (.blue, "doc.fill")
        case "petFeces": return (.green, "tortoise.fill")
        case "plastic": return (.yellow, "bag.fill")
        case "toners": return (.black, "printer.fill")
        default: return (.red, "exclamationmark.triangle.fill")
        }
    }
}

class MapCoordinator: NSObject, MKMapViewDelegate {
    var mapViewRepresentable: MapViewRepresentable
    var userHasInteractedWithMap = false

    init(_ mapViewRepresentable: MapViewRepresentable) {
        self.mapViewRepresentable = mapViewRepresentable
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if mapView.isUserInteractionEnabled {
            userHasInteractedWithMap = true
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        Task {
            await mapViewRepresentable.trashTagsViewModel.fetchTrashTags(center: mapView.centerCoordinate)
            DispatchQueue.main.async {
                self.mapViewRepresentable.updateAnnotations(from: mapView)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let trashAnnotation = annotation as? TrashAnnotation else {
            return nil
        }

        let identifier = "TrashAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.glyphImage = UIImage(systemName: trashAnnotation.iconName ?? "questionmark")
        annotationView?.markerTintColor = trashAnnotation.color
        
        configureAnnotationView(annotationView, with: trashAnnotation)

        return annotationView
    }
    
    private func configureAnnotationView(_ annotationView: MKMarkerAnnotationView?, with annotation: TrashAnnotation) {
        annotationView?.canShowCallout = true
        
        let bubbleView = UIView()
        bubbleView.backgroundColor = .white
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        let bubbleSize = CGSize(width: 200, height: 100)
        bubbleView.frame = CGRect(origin: CGPoint.zero, size: bubbleSize)
        annotationView?.detailCalloutAccessoryView = bubbleView
        
        if let color = annotation.color {
            annotationView?.markerTintColor = color
        }

        if let iconName = annotation.iconName, let glyphImage = UIImage(systemName: iconName) {
            annotationView?.glyphImage = glyphImage
            annotationView?.glyphTintColor = .white
        }
    }
}


