//
//  RegisterViewController.swift
//  WA8-10
//
//  Created by Angela Zheng on 11/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class VisitedCafesViewController: UIViewController {
    
    let visitedCafesView = VisitedCafesView()
    var visitedCafes = [Cafe]()
    
    override func loadView() {
        view = visitedCafesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visited"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        visitedCafesView.visitedCafesTableView.dataSource = self
        visitedCafesView.visitedCafesTableView.delegate = self
        
        visitedCafes = [
            Cafe(
                id: nil,
                name: "Matcha Maiko",
                coordinate: CLLocationCoordinate2D(latitude: 42.34269917074093, longitude: -71.09704044804509),
                avgRating: 3.0,
                reviews: [],
                images: []
            ),
            Cafe(id: nil,
                 name: "Kyo Matcha",
                 coordinate: CLLocationCoordinate2D(latitude: 42.34631876789066, longitude: -71.10735847575242),
                 avgRating: 4.0,
                 reviews: [],
                 images: []
                 )
        ]
    }
}


extension VisitedCafesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedCafes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitedCafes", for: indexPath) as! VisitedCafesTableViewCell
        cell.cafeNameLabel.text = visitedCafes[indexPath.row].name
        cell.starRating.rating = Int(visitedCafes[indexPath.row].avgRating)
        print("cafes", visitedCafes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getContactDetails(name: self.visitedCafesNames[indexPath.row])
    }
}
