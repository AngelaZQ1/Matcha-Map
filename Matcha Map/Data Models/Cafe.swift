//
//  Cafe.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import FirebaseFirestore

struct Cafe: Decodable {
    @DocumentID var id: String? // Firestore document ID
    var name: String
    var avgRating: Int
    var reviews: [Review]
    var images: [String] = [] // Array of image URLs
}

extension Cafe {
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? "",
            "name": name,
            "avgRating": avgRating,
            "reviews": reviews.map { $0.toDictionary() } // Convert each Review to a dictionary
        ]
    }
}


