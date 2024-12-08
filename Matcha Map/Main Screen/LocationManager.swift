//
import Foundation
import CoreLocation

extension ExploreViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        print("Authorization status: \(status.rawValue)") // Debugging authorization status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            print("Location permission not yet requested")
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status")
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Hide loading indicator once the location is updated
//        if !mainScreen.buttonLoading.isHidden {
//            mainScreen.buttonLoading.isHidden = true
//        }
        
        // Show the search button (or any other UI element that should be visible after fetching location)
//        if mainScreen.buttonSearch.isHidden {
//            mainScreen.buttonSearch.isHidden = false
//        }

        // Center the map to the current location
        mainScreen.mapView.centerToLocation(location: location)
    }


    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        print("Unable to determine your location. Please check your device settings.")
    }
}

