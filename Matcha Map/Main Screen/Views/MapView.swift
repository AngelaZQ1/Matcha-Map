import UIKit
import MapKit

class MapView: UIView {
    var mapView: MKMapView!
    var buttonCurrentLocation: UIButton!
    var buttonExplore: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupMapView()
        setupButtonCurrentLocation()
        setupButtonExplore()
        initConstraints()
    }
    
    func setupMapView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        self.addSubview(mapView)
    }
    
    func setupButtonCurrentLocation() {
        buttonCurrentLocation = UIButton(type: .system)
        buttonCurrentLocation.setImage(UIImage(systemName: "location.circle"), for: .normal)
        buttonCurrentLocation.layer.backgroundColor = UIColor.lightGray.cgColor
        buttonCurrentLocation.tintColor = .blue
        buttonCurrentLocation.layer.cornerRadius = 10
        buttonCurrentLocation.layer.shadowOffset = .zero
        buttonCurrentLocation.layer.shadowRadius = 4
        buttonCurrentLocation.layer.shadowOpacity = 0.7
        buttonCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCurrentLocation)
    }
    
    func setupButtonExplore() {
        buttonExplore = UIButton(type: .system) 
        buttonExplore.setTitle(" Explore Cafes ", for: .normal)
        buttonExplore.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonExplore.setImage(UIImage(systemName: "map.fill"), for: .normal)
        buttonExplore.layer.backgroundColor = UIColor(hex: "#71B90D").cgColor
        buttonExplore.tintColor = .white
        buttonExplore.layer.cornerRadius = 10
        buttonExplore.layer.shadowOffset = .zero
        buttonExplore.layer.shadowRadius = 4
        buttonExplore.layer.shadowOpacity = 0.7
        buttonExplore.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonExplore)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            buttonCurrentLocation.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            buttonCurrentLocation.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -8),
            buttonCurrentLocation.heightAnchor.constraint(equalToConstant: 36),
            buttonCurrentLocation.widthAnchor.constraint(equalToConstant: 36),
            
            buttonExplore.bottomAnchor.constraint(equalTo: buttonCurrentLocation.topAnchor, constant: -16),
            buttonExplore.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonExplore.heightAnchor.constraint(equalToConstant: 44),
            buttonExplore.widthAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
