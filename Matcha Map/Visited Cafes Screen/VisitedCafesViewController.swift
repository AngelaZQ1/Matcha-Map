//
//  RegisterViewController.swift
//  WA8-10
//
//  Created by Angela Zheng on 11/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VisitedCafesViewController: UIViewController {
    
    let visitedCafesView = VisitedCafesView()
    var visitedCafes = [Cafe]()
    
    override func loadView() {
        view = visitedCafesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cafes You've Visited"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        visitedCafesView.visitedCafesTableView.dataSource = self
        visitedCafesView.visitedCafesTableView.delegate = self
        
        visitedCafes = [
            Cafe(name: "Matcha Maiko", avgRating: 4, reviews: []),
            Cafe(name: "Kyo Matcha", avgRating: 3, reviews: [])
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
        cell.starRating.rating = visitedCafes[indexPath.row].avgRating
        print("cafes", visitedCafes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getContactDetails(name: self.visitedCafesNames[indexPath.row])
    }
}
