//
//  User.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import FirebaseFirestore

struct User: Decodable {
    @DocumentID var id: String? // Firestore document ID, optional to handle cases where it's not available initially
    var username: String
    var email: String
    var favCafe: String
    var favDrink: String
    var profilePic: UIImageView
    var visitedCafes: [Cafe]
    var reviews: [Review]
}

