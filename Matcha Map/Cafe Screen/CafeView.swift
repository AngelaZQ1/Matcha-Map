//
//  MainScreenView.swift
//  App11
//
//  Created by Sakib Miazi on 5/26/23.
//

import UIKit

class CafeView: UIView {
    var cafeNameLabel: UILabel!
    var starRating: StarRatingView!
    var numberRatingLabel: UILabel!
    var numReviewsLabel: UILabel!
    var visitedButton:UIButton!
    
    var reviewsLabel: UILabel!
    var addReviewButton: UIButton!
    
    var reviewsTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupCafeNameLabel()
        setupStarRating()
        setupNumberRatingLabel()
        setupNumReviewsLabel()
        setupVisitedButton()
        
        setupReviewsLabel()
        setupAddReviewButton()
        
        setupReviewsTableView()
        
        initConstraints()
    }
    func setupCafeNameLabel(){
        cafeNameLabel = UILabel()
        cafeNameLabel.font = UIFont.systemFont(ofSize: 22)
        cafeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cafeNameLabel)
    }
    func setupStarRating() {
        starRating = StarRatingView()
        starRating.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(starRating)
    }
    func setupNumberRatingLabel(){
        numberRatingLabel = UILabel()
        numberRatingLabel.font = UIFont.systemFont(ofSize: 12)
        numberRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(numberRatingLabel)
    }
    func setupNumReviewsLabel(){
        numReviewsLabel = UILabel()
        numReviewsLabel.font = UIFont.systemFont(ofSize: 12)
        numReviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(numReviewsLabel)
    }
    func setupVisitedButton(){
        visitedButton = UIButton(type: .system)
        visitedButton.setTitle("Not Visited", for: .normal)
        visitedButton.setTitleColor(.white, for: .normal)
        visitedButton.translatesAutoresizingMaskIntoConstraints = false
        visitedButton.layer.cornerRadius = 8
        visitedButton.backgroundColor = .blue
        visitedButton.clipsToBounds = true
        self.addSubview(visitedButton)
    }
    func setupReviewsLabel(){
        reviewsLabel = UILabel()
        reviewsLabel.text = "Reviews"
        reviewsLabel.font = UIFont.boldSystemFont(ofSize: 24)
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reviewsLabel)
    }
    func setupAddReviewButton(){
        addReviewButton = UIButton(type: .system)
        addReviewButton.setTitle("Add a Review!", for: .normal)
        addReviewButton.setTitleColor(.white, for: .normal)
        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
        addReviewButton.backgroundColor = .blue
        addReviewButton.layer.cornerRadius = 8
        addReviewButton.clipsToBounds = true
        self.addSubview(addReviewButton)
    }
    func setupReviewsTableView() {
        reviewsTableView = UITableView()
        reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "reviews")
        reviewsTableView.translatesAutoresizingMaskIntoConstraints = false
        reviewsTableView.separatorColor = UIColor.lightGray
        reviewsTableView.separatorInset = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: -16)
        reviewsTableView.rowHeight = UITableView.automaticDimension // Dynamic height

        self.addSubview(reviewsTableView)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            cafeNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cafeNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            starRating.topAnchor.constraint(equalTo: cafeNameLabel.bottomAnchor, constant: 8),
            starRating.leadingAnchor.constraint(equalTo: cafeNameLabel.leadingAnchor, constant: 10),
            starRating.heightAnchor.constraint(equalToConstant: 25),
            starRating.widthAnchor.constraint(equalToConstant: 110),
            
            numberRatingLabel.leadingAnchor.constraint(equalTo: starRating.trailingAnchor, constant: 12),
            numberRatingLabel.centerYAnchor.constraint(equalTo: starRating.centerYAnchor, constant: 2),
            
            numReviewsLabel.leadingAnchor.constraint(equalTo: numberRatingLabel.trailingAnchor, constant: 5),
            numReviewsLabel.centerYAnchor.constraint(equalTo: numberRatingLabel.centerYAnchor),
            
            visitedButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            visitedButton.bottomAnchor.constraint(equalTo: numReviewsLabel.bottomAnchor),
            visitedButton.heightAnchor.constraint(equalToConstant: 40),
            visitedButton.widthAnchor.constraint(equalToConstant: 110),
            
            reviewsLabel.topAnchor.constraint(equalTo: numReviewsLabel.bottomAnchor, constant: 32),
            reviewsLabel.leadingAnchor.constraint(equalTo: starRating.leadingAnchor),
            
            addReviewButton.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 8),
            addReviewButton.leadingAnchor.constraint(equalTo: cafeNameLabel.leadingAnchor),
            addReviewButton.heightAnchor.constraint(equalToConstant: 40),
            addReviewButton.widthAnchor.constraint(equalToConstant: 120),
            
            reviewsTableView.topAnchor.constraint(equalTo: addReviewButton.bottomAnchor, constant: 16),
            reviewsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            reviewsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            reviewsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
