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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
        guard let annotation = annotation as? Place else { return nil }
        
        var view:MKMarkerAnnotationView
        
        if let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: Configs.placeIdentifier) as? MKMarkerAnnotationView{
            annotationView.annotation = annotation
            view = annotationView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Configs.placeIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
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
