import MapKit

class Place: NSObject, MKAnnotation {
    let id: String?
    var name: String?
    var coordinate: CLLocationCoordinate2D
    var avgRating: Double
    var reviews: [String]?
    var images: [String]?
    
    // MKAnnotation properties
    var title: String? { name }
    var subtitle: String? { "Rating: \(avgRating)" }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinate
        case avgRating
        case reviews
        case images
    }
    
    init(id: String? = nil, name: String, coordinate: CLLocationCoordinate2D, avgRating: Double, reviews: [String]?, images: [String]?) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.avgRating = avgRating
        self.reviews = reviews
        self.images = images
    }
    
    var mapItem: MKMapItem?{
        guard let location = name else{
            return nil
        }
        
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary:  [:]
        )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
        
        //    required init(from decoder: Decoder) throws {
        //        let container = try decoder.container(keyedBy: CodingKeys.self)
        //        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        //        self.name = try container.decode(String.self, forKey: .name)
        //
        //        let coordinateArray = try container.decode([Double].self, forKey: .coordinate)
        //        guard coordinateArray.count == 2 else {
        //            throw DecodingError.dataCorruptedError(forKey: .coordinate, in: container, debugDescription: "Coordinate must contain exactly 2 values.")
        //        }
        //        self.coordinate = CLLocationCoordinate2D(latitude: coordinateArray[0], longitude: coordinateArray[1])
        //        self.avgRating = try container.decode(Double.self, forKey: .avgRating)
        //        self.reviews = try container.decode([String].self, forKey: .reviews)
        //        self.images = try container.decode([String].self, forKey: .images)
        //    }
    
}
