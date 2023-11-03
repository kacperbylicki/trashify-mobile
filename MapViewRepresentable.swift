//
//  MapViewRepresentable.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI
import MapKit

struct Trash {
    let uuid: String
    let geolocation: [Float]
    let tag: String
}

class TrashAnnotation: MKPointAnnotation {
    var uuid: String?
    var color: UIColor?
    var iconName: String?
}

struct MapViewRepresentable: UIViewRepresentable {
    private let mapView = MKMapView()

    @EnvironmentObject private var locationViewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> UIView {
        configureMapView(with: context.coordinator)
        return mapView
    }

    private func configureMapView(with delegate: MKMapViewDelegate) {
        mapView.delegate = delegate
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let updatedMapView = uiView as? MKMapView else { return }
        
        updatedMapView.removeAnnotations(updatedMapView.annotations)
        
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            centerMap(to: coordinate, on: updatedMapView)
            for trashItemInDistance in locationViewModel.trashItems {
                let trashItem = Trash(uuid: trashItemInDistance.uuid, geolocation: trashItemInDistance.geolocation, tag: trashItemInDistance.tag)
                addTrashPin(using: trashItem, to: updatedMapView)
            }

        }
    }

    private func centerMap(to coordinate: CLLocationCoordinate2D, on mapView: MKMapView) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    private func addTrashPin(using trashItem: Trash, to mapView: MKMapView) {
        let annotation = TrashAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(trashItem.geolocation[1]), longitude: CLLocationDegrees(trashItem.geolocation[0]))
        annotation.title = trashItem.tag
        annotation.uuid = trashItem.uuid

        let (color, iconName) = getAppearance(forTag: trashItem.tag)
        annotation.color = color
        annotation.iconName = iconName

        mapView.addAnnotation(annotation)
    }

    private func getAppearance(forTag tag: String) -> (UIColor, String) {
        switch tag {
        case "batteries": return (.black, "battery.100")
        case "bio": return (.brown, "leaf.arrow.circlepath")
        case "bottleMachine": return (.blue, "cart.fill.badge.plus")
        case "mixed": return (.gray, "cube.box.fill")
        case "municipal": return (.black, "building.columns.fill")
        case "paper": return (.brown, "doc.fill")
        case "petFeces": return (.darkGray, "tortoise.fill")
        case "plastic": return (.cyan, "bag.fill")
        case "toners": return (.purple, "printer.fill")
        default: return (.red, "exclamationmark.triangle.fill")
        }
    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: MapViewRepresentable

        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            parent.locationViewModel.userLocation = userLocation.coordinate
            
            if parent.locationViewModel.shouldRefocusOnUser {
                let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                parent.mapView.setRegion(region, animated: true)
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let trashAnnotation = annotation as? TrashAnnotation else { return nil }
            
            let identifier = "TrashAnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: trashAnnotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = trashAnnotation
            }
            
            configureAnnotationView(annotationView, with: trashAnnotation)

            return annotationView
        }

        private func configureAnnotationView(_ annotationView: MKMarkerAnnotationView?, with annotation: TrashAnnotation) {
            annotationView?.canShowCallout = true
            annotationView?.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)

            if let color = annotation.color {
                annotationView?.markerTintColor = color
            }

            if let iconName = annotation.iconName {
                annotationView?.glyphImage = UIImage(systemName: iconName)
                annotationView?.glyphTintColor = UIColor.white
            }
        }
    }
}
