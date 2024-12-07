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
                    // If not logged in, show login screen
                    let loginVC = LogInViewController()
                    self.navigationController?.pushViewController(loginVC, animated: false)
                }
        // Listen to authentication state changes
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.reloadUserProfile { refreshedUser in
                    self.currentUser = refreshedUser
                 

                    // Set up navigation bar for logged in user
//                    self.setupRightBarButton(isLoggedin: true)
                    
                    // Fetch cafes for the current user
//                    self.fetchCafes()
                }
            } else {
                // Handle sign-out
                self.currentUser = nil
//                self.mainScreen.labelText.text = "Please sign in!"
                
                
                // Reset chat list and reload table
                self.cafeList.removeAll()
                //self.mainScreen.tableViewChats.reloadData()
                //self.setupRightBarButton(isLoggedin: false)
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
        
        title = "Explore"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: add action for current location button tap...
        mainScreen.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        
        //MARK: add action for bottom search button tap...
//        mapView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
        
        //MARK: setting up location manager...
        setupLocationManager()
        
        //MARK: center the map view to current location when the app loads...
        onButtonCurrentLocationTapped()
        
        fetchLocationsFromFirestore()
        //MARK: Annotating Northeastern University...
        let northeastern = Place(
            title: "Northeastern University",
            coordinate: CLLocationCoordinate2D(latitude: 42.339918, longitude: -71.089797),
            info: "LVX VERITAS VIRTVS"
        )
        
        mainScreen.mapView.addAnnotation(northeastern)
        mainScreen.mapView.delegate = self
        
        addNotificationCenterObservers()
    }
    
    @objc func onButtonCurrentLocationTapped(){
            if let uwLocation = locationManager.location{
                mainScreen.mapView.centerToLocation(location: uwLocation)
            }
            
        }
    private func fetchLocationsFromFirestore() {
            // Fetch documents from "locations" collection
            database.collection("cafes").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching locations: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No locations found")
                    return
                }
                
                // Parse documents into Place objects and add to the map
                for document in documents {
                    let data = document.data()
                    
                    guard let name = data["name"] as? String,
                              let avgRating = data["avgRating"] as? Double,
                              let coordinateData = data["coordinate"] as? GeoPoint else {
                            print("Invalid data format for document: \(document.documentID)")
                            continue
                        }
                        
                        // Extract coordinate from GeoPoint
                        let coordinate = CLLocationCoordinate2D(latitude: coordinateData.latitude, longitude: coordinateData.longitude)
                    let info = String(avgRating) + "rating out of five"
                    let place = Place(
                        title: name,
                        coordinate: coordinate,
                        info: info
                    )
                    
                    // Add annotation to the map
                    self.mainScreen.mapView.addAnnotation(place)
                    self.cafeList.append(place)
                }
            }
        }


    
    @objc func setupBottomSheet(){
        
        //MARK: Setting up bottom search sheet...
        let searchViewController  = SearchViewController()
        searchViewController.delegateToMapView = self
        
        let navForSearch = UINavigationController(rootViewController: searchViewController)
        navForSearch.modalPresentationStyle = .pageSheet
        
        if let searchBottomSheet = navForSearch.sheetPresentationController{
            searchBottomSheet.detents = [.medium(), .large()]
            searchBottomSheet.prefersGrabberVisible = true
        }
        
        present(navForSearch, animated: true)
    }
    
    //MARK: show selected place on map...
    func showSelectedPlace(placeItem: MKMapItem){
        let coordinate = placeItem.placemark.coordinate
        mainScreen.mapView.centerToLocation(
            location: CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        )
        let place = Place(
            title: placeItem.name!,
            coordinate: coordinate,
            info: placeItem.description
        )
        mainScreen.mapView.addAnnotation(place)
    }

}

extension MKMapView{
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
