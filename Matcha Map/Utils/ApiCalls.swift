//
//  ApiCalls.swift
//  Matcha Map
//
//  Created by Angela Zheng on 12/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class ApiCalls {
    func getCafeByName(_ cafeName: String, completion: @escaping (Result<Cafe, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("cafes")
            .whereField("name", isEqualTo: cafeName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching cafe: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("Error: Cafe not found")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cafe not found"])))
                    return
                }
                
                do {
                    // Map Firestore document data to a Cafe object
                    if let data = document.data() as? [String: Any] {
                        // Parse coordinate
                        guard let geoPoint = data["coordinate"] as? GeoPoint else {
                            throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid coordinate data"])
                        }
                        
                        let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                        
                        let cafe = Cafe(
                            id: document.documentID,
                            name: data["name"] as? String ?? "Unknown",
                            coordinate: coordinate,
                            avgRating: data["avgRating"] as? Double ?? 0.0,
                            reviews: data["reviews"] as? [String],
                            images: data["images"] as? [String]
                        )
                        
                        completion(.success(cafe))
                    } else {
                        throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                    }
                } catch {
                    print("Error creating Cafe object: \(error.localizedDescription)")
                    completion(.failure(error))
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
