import Foundation
import FirebaseFirestore
import MapKit

// Cafe struct with Decodable conformance
struct Cafe: Decodable {
    let id: String?
    var name: String
    var coordinate: CLLocationCoordinate2D
    var avgRating: Double
    var reviews: [Review]
    var images: [String]  // Array of image URLs as strings
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinate
        case avgRating
        case reviews
        case images
    }

    // Custom initializer for direct instantiation
    init(id: String? = nil, name: String, coordinate: CLLocationCoordinate2D, avgRating: Double, reviews: [Review], images: [String]) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.avgRating = avgRating
        self.reviews = reviews
        self.images = images
    }

    // Decoding initializer for Firestore data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        let coordinateArray = try container.decode([Double].self, forKey: .coordinate)
        guard coordinateArray.count == 2 else {
            throw DecodingError.dataCorruptedError(
                forKey: .coordinate,
                in: container,
                debugDescription: "Coordinate must contain exactly 2 values: latitude and longitude"
            )
        }
        self.coordinate = CLLocationCoordinate2D(latitude: coordinateArray[0], longitude: coordinateArray[1])
        
        self.avgRating = try container.decode(Double.self, forKey: .avgRating)
        self.reviews = try container.decode([Review].self, forKey: .reviews)
        self.images = try container.decode([String].self, forKey: .images) // Array of URLs
    }

    // toDictionary method for Firestore saving
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? "",
            "name": name,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "avgRating": avgRating,
            "reviews": reviews.map { $0.toDictionary() },
            "images": images // Array of URLs as strings
        ]
    }
}
