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
//    var images: figure out type that works with firebase storage
}

