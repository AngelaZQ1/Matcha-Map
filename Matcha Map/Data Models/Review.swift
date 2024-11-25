//
//  Review.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import FirebaseFirestore

struct Review: Decodable {
    @DocumentID var id: String? // Firestore document ID
    var user: String
    var cafe: Cafe
    var rating: Int
    var title: String
    var details: String
    var images: [String] = [] // Array of image URLs
}

extension Review {
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? "",
            "user": user,
            "cafe": cafe.toDictionary(), // Convert Cafe to a dictionary
            "rating": rating,
            "title": title,
            "details": details
        ]
    }
}


