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
                    // Setup Tab Bar
//                    self.setupTabBarController()
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
        
        mainScreen.buttonExplore.addTarget(self, action: #selector(setupBottomSheet), for: .touchUpInside)
        mainScreen.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        setupLocationManager()
        onButtonCurrentLocationTapped()
        
        mainScreen.mapView.delegate = self
        addNotificationCenterObservers()
        
    
    }


    func signoutUser() {
        // Assuming you have a reference to the current user
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }

            do {
                try Auth.auth().signOut()
                print("User deleted and signed out successfully")

                // Optionally, you can navigate to the login screen or clear other app data
                self.navigateToLoginScreen()

            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        
    }

    func navigateToLoginScreen() {
        // Assuming you have a navigation controller
        if let navigationController = self.navigationController {
            let loginVC = LogInViewController() // Replace with your login view controller
            navigationController.pushViewController(loginVC, animated: true)
        }
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
    
    //MARK: Tab Bar Controller Setup
    func setupTabBarController() {
        // Create the visited, explore, and profile view controllers
        let visitedVC = VisitedCafesViewController()
        visitedVC.view.backgroundColor = .white
        visitedVC.tabBarItem = UITabBarItem(title: "Visited", image: UIImage(systemName: "checkmark.circle"), selectedImage: UIImage(systemName: "checkmark.circle.fill"))

        let exploreVC = self // This view controller (Explore screen)
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        let profileVC = ProfilePageViewController()

        // Fetch user data and set it to the profileVC
        fetchUserFromFirestore { user in
            DispatchQueue.main.async {
                profileVC.user = user // Pass the fetched user here
                profileVC.view.backgroundColor = .white
                profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
                
                // Create tabBarController after setting the profileVC
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [visitedVC, exploreVC, profileVC]
                tabBarController.tabBar.tintColor = .systemGreen
                tabBarController.tabBar.unselectedItemTintColor = .gray

                // Add the TabBarController as a child
                self.addChild(tabBarController)
                self.view.addSubview(tabBarController.view)
                tabBarController.didMove(toParent: self)
            }
        }
    }


    func fetchUserFromFirestore(completion: @escaping (User?) -> Void) {
        print("called")
        
        // Ensure the user is logged in
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently logged in.")
            completion(nil)
            return
        }
        
        // Get reference to Firestore document
        let userRef = Firestore.firestore().collection("users").document(currentUser.email ?? "")
        
        // Fetch the document
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check if document exists
            guard let document = document, document.exists else {
                print("User document does not exist.")
                completion(nil)
                return
            }
            
            // Fetch and handle document data
            var data = document.data() ?? [:]
            
            // Ensure missing fields are handled properly
            data["favCafe"] = data["favCafe"] as? String ?? ""  // Empty string if missing
            data["favDrink"] = data["favDrink"] as? String ?? ""  // Empty string if missing
            data["visitedCafes"] = data["visitedCafes"] as? [[String: Any]] ?? []  // Array of dictionaries if missing
            data["reviews"] = data["reviews"] as? [[String: Any]] ?? []  // Array of dictionaries if missing
            
            // Print data to check its contents (for debugging)
            print(data)
            
            // Directly map Firestore data to the User model
            do {
                let user = User(
                    id: data["email"] as? String ?? "", // Use optional binding to safely unwrap
                    username: data["username"] as? String ?? "", // Default empty string if missing
                    email: data["email"] as? String ?? "",
                    favCafe: data["favCafe"] as? String ?? "",
                    favDrink: data["favDrink"] as? String ?? "",
                    profilePicURL: data["profilePicURL"] as? String,
                    visitedCafes: (data["visitedCafes"] as? [[String: Any]])?.compactMap { cafeData in
                        // Decode each cafe dictionary to a Cafe object
                        guard let name = cafeData["name"] as? String,
                              let avgRating = cafeData["avgRating"] as? Double else {
                            return nil
                        }
                        let coordinateArray = cafeData["coordinate"] as? [Double] ?? []
                        guard coordinateArray.count == 2 else { return nil }
                        let coordinate = CLLocationCoordinate2D(latitude: coordinateArray[0], longitude: coordinateArray[1])
                        return Cafe(id: cafeData["id"] as? String, name: name, coordinate: coordinate, avgRating: avgRating, reviews: cafeData["reviews"] as? [String], images: cafeData["images"] as? [String])
                    } ?? [],
                    reviews: (data["reviews"] as? [[String: Any]])?.compactMap { reviewData in
                        // Decode each review dictionary to a Review object
                        guard let user = reviewData["user"] as? String,
                              let rating = reviewData["rating"] as? Int,
                              let title = reviewData["title"] as? String,
                              let details = reviewData["details"] as? String else {
                            return nil
                        }
                        let cafe = Cafe(id: reviewData["cafe"] as? String, name: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), avgRating: 0, reviews: nil, images: nil) // You might want to handle this properly
                        return Review(id: reviewData["id"] as? String, user: user, cafe: cafe, rating: rating, title: title, details: details, images: reviewData["images"] as? [String] ?? [])
                    } ?? []
                )
                
                print("User successfully decoded: \(user)")
                completion(user)
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
                completion(nil)
            }
        }
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

