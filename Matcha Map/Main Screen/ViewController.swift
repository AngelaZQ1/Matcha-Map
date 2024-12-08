//
//  ViewController.swift
//  App14
//
//  Created by Sakib Miazi on 6/14/23.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

//MARK: EXPLORE SCREEN

class ViewController: UIViewController {
    let mainScreen = MapView()
    var cafeList = [Place]()
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    let database = Firestore.firestore()
    
    let locationManager = CLLocationManager()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginVC = LogInViewController()
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
        
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.reloadUserProfile { refreshedUser in
                    self.currentUser = refreshedUser
                    self.cafeList.removeAll()
                    self.fetchLocationsFromFirestore()
                }
            } else {
                self.currentUser = nil
                self.cafeList.removeAll()
            }
        }
    }

    private func reloadUserProfile(completion: @escaping (FirebaseAuth.User?) -> Void) {
        Auth.auth().currentUser?.reload { error in
            if error == nil {
                completion(Auth.auth().currentUser)
            } else {
                print("Error refreshing user profile: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Explore"
//        navigationController?.navigationBar.prefersLargeTitles = false
        
        mainScreen.buttonExplore.addTarget(self, action: #selector(setupBottomSheet), for: .touchUpInside)

        mainScreen.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        setupLocationManager()
        onButtonCurrentLocationTapped()
        
        mainScreen.mapView.delegate = self
        addNotificationCenterObservers()
    }
    
    @objc func onButtonCurrentLocationTapped() {
        if let uwLocation = locationManager.location {
            mainScreen.mapView.centerToLocation(location: uwLocation)
        } else {
            let defaultLocation = CLLocation(latitude: 42.339918, longitude: -71.089797)
            mainScreen.mapView.centerToLocation(location: defaultLocation)
        }
    }
    
    private func fetchLocationsFromFirestore() {
        database.collection("cafes").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching cafes: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No cafes found")
                return
            }

            for document in documents {
                let data = document.data()

                guard
                    let name = data["name"] as? String,
                    let avgRating = data["avgRating"] as? Double,
                    let coordinateData = data["coordinate"] as? GeoPoint,
                    let reviews = data["reviews"] as? [String],
                    let images = data["images"] as? [String]
                else {
                    print("Invalid data format for document: \(document.documentID)")
                    continue
                }

                let coordinate = CLLocationCoordinate2D(latitude: coordinateData.latitude, longitude: coordinateData.longitude)
                let place = Place(
                    id: document.documentID,
                    name: name,
                    coordinate: coordinate,
                    avgRating: avgRating,
                    reviews: reviews,
                    images: images
                )

                self.cafeList.append(place)
                self.mainScreen.mapView.addAnnotation(place)
            }

            // Call setupBottomSheet after fetching cafes
            self.setupBottomSheet()
        }
    }
    
    @objc func setupBottomSheet() {
        let cafeBottomSheetController = CafeBottomSheetController()
        cafeBottomSheetController.cafes = cafeList
        cafeBottomSheetController.modalPresentationStyle = .pageSheet
        if let sheet = cafeBottomSheetController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(cafeBottomSheetController, animated: true)
    }
    
    func showSelectedPlace(placeItem: MKMapItem) {
        let coordinate = placeItem.placemark.coordinate
        mainScreen.mapView.centerToLocation(
            location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        )

        let place = Place(
            id: nil,
            name: placeItem.name ?? "Unknown",
            coordinate: coordinate,
            avgRating: 0.0,
            reviews: [],
            images: []
        )
        mainScreen.mapView.addAnnotation(place)
    }
}

extension MKMapView {
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
