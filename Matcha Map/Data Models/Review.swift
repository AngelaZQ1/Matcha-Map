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
    var images: [UIImageView]
}

