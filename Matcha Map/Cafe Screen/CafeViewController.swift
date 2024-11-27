//
//  SignUpViewController.swift
//  App11
//
//  Created by Angela Zheng on 10/28/24.
//

import UIKit

class CafeViewController: UIViewController {
    let cafeView = CafeView()
    let notificationCenter = NotificationCenter.default
    
    var cafe: Cafe!
    var reviews = [Review]()
    
    override func loadView() {
        view = cafeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cafe 1"
        
        cafeView.reviewsTableView.dataSource = self
        cafeView.reviewsTableView.delegate = self
        
        cafeView.numberRatingLabel.text = "4.2"
        cafeView.numReviewsLabel.text = "(10 reviews)"
        
        var matchaMaiko = Cafe(name: "Matcha Maiko", avgRating: 3, reviews: [])
        
        cafe = matchaMaiko
        
        reviews = [
            Review(user: "angela", cafe: matchaMaiko, rating: 3, title: "great masdlkf jsdfhasdjkhfj sdsf dtcha", details: "review detalsdkjf laksjf sdklj lsafldjf lfjskdj aksj kljsdfl kajlkdslk fjalkf lkasdjfk jsadljf ksdljf klasdj fkljlfd asdf dsf sd fadsils"),
            Review(user: "mathena", cafe: matchaMaiko, rating: 4, title: "very good matcha", details: "details"),
        ]
        
        matchaMaiko.reviews = reviews
        
        cafeView.addReviewButton.addTarget(self, action: #selector(onAddReviewTapped), for: .touchUpInside)
    }
    
    @objc func onAddReviewTapped() {
        notificationCenter.post(
            name: Notification.Name("addReview"),
            object: nil,
            userInfo: ["cafe": cafe as Cafe])
    }
}

extension CafeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviews", for: indexPath) as! ReviewsTableViewCell
        cell.usernameLabel.text = reviews[indexPath.row].user
        cell.starRating.rating = reviews[indexPath.row].rating
        cell.reviewTitleLabel.text = reviews[indexPath.row].title
        cell.reviewDetailsLabel.text = reviews[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getContactDetails(name: self.visitedCafesNames[indexPath.row])
    }
}
