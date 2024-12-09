import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class VisitedCafesViewController: UIViewController {
    
    let visitedCafesView = VisitedCafesView()
    var visitedCafes = [String]() // Store only cafe IDs
    var cafes = [Cafe]() // Store full cafe details
    var userReviews = [String: Int]() // Store user ratings for each cafe, using cafe ID as the key
    // Create a dictionary to map cafe names to their IDs
    var cafeIdToNameMap = [String: String]()
    
    override func loadView() {
        print("loadView called")
        view = visitedCafesView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload data when the tab is selected
        fetchVisitedCafesFromFirestore() // Ensure data is refreshed each time the tab is selected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visited"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        visitedCafesView.visitedCafesTableView.dataSource = self
        visitedCafesView.visitedCafesTableView.delegate = self
        
        // Ensure the table view has the correct cell registered
        visitedCafesView.visitedCafesTableView.register(VisitedCafesTableViewCell.self, forCellReuseIdentifier: "visitedCafes")
    }
    
    // Fetch visited cafes data from Firestore
    func fetchVisitedCafesFromFirestore() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently logged in.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUser.email ?? "")
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist.")
                return
            }
            
            let data = document.data() ?? [:]
            let visitedCafesData = data["visitedCafes"] as? [String] ?? [] // Now an array of cafe IDs
            self.visitedCafes = visitedCafesData
            print(self.visitedCafes)
            // Now fetch the full cafe details using the visited cafe IDs
            self.fetchCafesDetails(cafeIds: visitedCafesData) {
                // Once cafe details are fetched, fetch user reviews
                self.fetchUserReviews(currentUserId: currentUser.email ?? "")
            }
        }
    }

    // Fetch full cafe details by their IDs (without batch)
    func fetchCafesDetails(cafeIds: [String], completion: @escaping () -> Void) {
        let cafesRef = Firestore.firestore().collection("cafes")
        
        // Fetch each cafe's details individually
        for cafeId in cafeIds {
            let cafeRef = cafesRef.document(cafeId)
            
            // Check if cafe already exists in the array before fetching
            if cafes.contains(where: { $0.id == cafeId }) {
                continue // Skip if cafe already exists
            }
            
            cafeRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching cafe details: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("Cafe document does not exist for ID: \(cafeId)")
                    return
                }
                
                let cafeData = document.data() ?? [:]
                if let name = cafeData["name"] as? String,
                   let avgRating = cafeData["avgRating"] as? Double {
                    
                    // Handle GeoPoint for coordinates
                    if let geoPoint = cafeData["coordinate"] as? GeoPoint {
                        let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                        
                        self.cafes.append(Cafe(
                            id: cafeData["id"] as? String,
                            name: name,
                            coordinate: coordinate,
                            avgRating: avgRating,
                            reviews: cafeData["reviews"] as? [String] ?? [],
                            images: cafeData["images"] as? [String] ?? []
                        ))
                    }
                }
                
                // After fetching all cafes, reload the table view
                DispatchQueue.main.async {
                    self.visitedCafesView.visitedCafesTableView.reloadData()
                }
                
                // If all cafes are fetched, call the completion handler
                if self.cafes.count == cafeIds.count {
                    completion()
                }
            }
        }
    }

    // Fetch the user's reviews for each visited cafe
    func fetchUserReviews(currentUserId: String) {
        let reviewsRef = Firestore.firestore().collection("reviews")
        let cafesRef = Firestore.firestore().collection("cafes")
        // Fetch all cafes to build the mapping
        cafesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching cafes: \(error.localizedDescription)")
                return
            }
            
            // Build the map of cafe names to IDs
            snapshot?.documents.forEach { document in
                let cafeData = document.data()
                if let name = cafeData["name"] as? String {
                    self.cafeIdToNameMap[document.documentID] = name
                }
            }
        }
        // Create a dictionary to map cafe names to their IDs
        var cafeNameToIdMap = [String: String]()
        
        // Fetch all cafes to build the mapping
        cafesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching cafes: \(error.localizedDescription)")
                return
            }
            
            // Build the map of cafe names to IDs
            snapshot?.documents.forEach { document in
                let cafeData = document.data()
                if let name = cafeData["name"] as? String {
                    cafeNameToIdMap[name] = document.documentID
                }
            }
            
            // Now, fetch the reviews for the current user
            reviewsRef.whereField("user", isEqualTo: currentUserId).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching reviews: \(error.localizedDescription)")
                    return
                }
                // Store the most recent review for each visited cafe
                var mostRecentReviews = [String: Int]() // Temporary dictionary to store most recent reviews
                
                snapshot?.documents.forEach { document in
                    let reviewData = document.data()
                    if let cafeName = reviewData["cafe"] as? String, let rating = reviewData["rating"] as? Int {
                        // Get the cafe ID from the map based on the cafe name
                        if let cafeId = cafeNameToIdMap[cafeName] {
                            // Only consider cafes that are in the visitedCafes list
                            if self.visitedCafes.contains(cafeId) {
                                // Store or update the most recent review for this cafe
                                mostRecentReviews[cafeId] = rating
                            }
                        }
                    }
                }
                
                // Update the userReviews dictionary with the most recent ratings
                self.userReviews = mostRecentReviews
                
                // Print the user reviews for debugging
                print("Most recent reviews: \(self.userReviews)")
                
                // Reload the table view with the most recent ratings
                DispatchQueue.main.async {
                    self.visitedCafesView.visitedCafesTableView.reloadData()
                }
            }
        }
    }

}

extension VisitedCafesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedCafes.count // Using cafes array which contains full details
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cafesRef = Firestore.firestore().collection("cafes")
        
        
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitedCafes", for: indexPath) as! VisitedCafesTableViewCell
        let cafe = visitedCafes[indexPath.row]
        cell.cafeNameLabel.text = cafeIdToNameMap[cafe]
        
        // Set the star rating based on the user's most recent review for the cafe
        if let userRating = userReviews[cafe ?? ""] {
            cell.starRating.rating = userRating
        } else {
            cell.starRating.rating = 0 // Default rating if no review exists
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}
