import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit
class ViewController: UITabBarController {

    private var currentUser: FirebaseAuth.User?
    private let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    func setupViewControllers() {
        // Create the visited, explore, and profile view controllers
        let visitedVC = VisitedCafesViewController()
        visitedVC.view.backgroundColor = .white
        visitedVC.tabBarItem = UITabBarItem(title: "Visited", image: UIImage(systemName: "checkmark.circle"), selectedImage: UIImage(systemName: "checkmark.circle.fill"))

        let exploreVC = ExploreViewController() // The Explore screen (this will be the current VC)
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        let profileVC = ProfilePageViewController()
        // needed for the title and "edit profile" buttons to show up
        let profileNavVC = UINavigationController(rootViewController: profileVC)


        // Fetch user data and set it to the profileVC
        fetchUserFromFirestore { user in
            DispatchQueue.main.async {
                profileVC.user = user // Pass the fetched user here
                profileVC.view.backgroundColor = .white
                profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
                
                // Create tabBarController after setting the profileVC
                self.viewControllers = [visitedVC, exploreVC, profileNavVC]
                self.selectedViewController = exploreVC // Make sure the Explore VC is selected initially
                self.tabBar.tintColor = .systemGreen
                self.tabBar.unselectedItemTintColor = .gray
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
