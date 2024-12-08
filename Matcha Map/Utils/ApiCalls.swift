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

}
