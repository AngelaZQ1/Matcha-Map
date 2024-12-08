//
//  MapAnnotationDelegate.swift
//  App14
//  Repurposed from: https://www.hackingwithswift.com/read/16/3/annotations-and-accessory-views-mkpinannotationview
//  Created by Sakib Miazi on 6/14/23.
//

import Foundation
import MapKit
import FirebaseFirestore
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let place = annotation as? Place else { return nil }

            let identifier = "PlaceAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.pinTintColor = .red

                // Add custom callout button
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place else { return }

        let cafeName = annotation.title ?? ""  // Use cafe's name or another unique identifier

        // Navigate to CafeViewController and pass the cafe name
        let cafeViewController = CafeViewController()
        cafeViewController.cafeName = cafeName  // Passing the cafe name

        if let navigationController = view.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(cafeViewController, animated: true)
        } else if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
            navigationController.pushViewController(cafeViewController, animated: true)
        } else {
            print("Failed to find navigation controller")
        }
    }


}
