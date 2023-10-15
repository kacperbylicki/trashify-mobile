//
//  MapViewRepresentable.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager = LocationManager()

    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let mapView = uiView as? MKMapView else {
            return
        }

        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)

        if let coordinate = locationViewModel.selectedLocationCoordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }


    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(parent: self)
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
            if parent.locationViewModel.shouldRefocusOnUser {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                parent.mapView.setRegion(region, animated: true)
            }
        }
    }
}
