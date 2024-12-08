    //
    //  SignUpViewController.swift
    //  App11
    //
    //  Created by Angela Zheng on 10/28/24.
    //

    import UIKit
    import MapKit
    import FirebaseFirestore

    class CafeViewController: UIViewController {
        let cafeView = CafeView()
        let notificationCenter = NotificationCenter.default
        let db = Firestore.firestore() // Firestore database instance
        
        var cafe: Cafe!
        var reviews = [Review]()
        
        override func loadView() {
            view = cafeView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(refreshReviews), name: NSNotification.Name("NewReviewAdded"), object: nil)

            // Set the title to the cafe's name if available
            title = cafe.name ?? "Cafe Details"
            fetchReviews(for: cafe.id ?? "")
            // Set up table view
            cafeView.reviewsTableView.dataSource = self
            cafeView.reviewsTableView.delegate = self
            cafeView.cafeNameLabel.text = cafe.name
            cafeView.numReviewsLabel.text = "\(cafe.reviews?.count ?? 0) reviews"
            cafeView.numberRatingLabel.text = "\(cafe.avgRating)"


            // Add button action for adding reviews
            cafeView.addReviewButton.addTarget(self, action: #selector(onAddReviewTapped), for: .touchUpInside)
        }
        
        @objc func refreshReviews() {
                // Reload the reviews data from Firestore and update the table view
            fetchReviews(for: cafe.id ?? "" )
            }

        private func fetchReviews(for cafeId: String) {
            let db = Firestore.firestore()

            // Fetch the cafe document to get the review IDs
            db.collection("cafes").document(cafeId).getDocument { document, error in
                if let error = error {
                    print("Error fetching cafe document: \(error.localizedDescription)")
                    return
                }

                guard let document = document, document.exists,
                      let reviewIds = document.data()?["reviews"] as? [String] else {
                    print("No reviews found or reviews field is missing.")
                    return
                }

                // Fetch each review using the review IDs
                let reviewGroup = DispatchGroup()
                var fetchedReviews = [Review]()
                
                for reviewId in reviewIds {
                    reviewGroup.enter()
                    db.collection("reviews").document(reviewId).getDocument { reviewDocument, error in
                        if let error = error {
                            print("Error fetching review \(reviewId): \(error.localizedDescription)")
                        } else if let reviewDocument = reviewDocument, reviewDocument.exists {
                            if let reviewData = reviewDocument.data(),
                               let review = self.parseReview(from: reviewData) {
                                fetchedReviews.append(review)
                            }
                        }
                        reviewGroup.leave()
                    }
                }

                // Wait for all review fetch requests to complete
                reviewGroup.notify(queue: .main) {
                    self.reviews = fetchedReviews
                    print("fetched reviews \(fetchedReviews)")
                    // Update UI
                    self.cafeView.numReviewsLabel.text = "(\(self.reviews.count) reviews)"
                    self.cafeView.reviewsTableView.reloadData()
                }
            }
        }

        private func parseReview(from data: [String: Any]) -> Review? {
            // Ensure all required fields exist
            guard let user = data["user"] as? String,
                  let rating = data["rating"] as? Int,
                  let title = data["title"] as? String,
                  let details = data["details"] as? String else {
                print("Error parsing review: Missing data fields")
                return nil
            }

            // Create a new Review object
            return Review(user: user, cafe: cafe, rating: rating, title: title, details: details)
        }


        private func updateCafeDetails(from data: [String: Any]) {
            // Parse cafe data
            if let name = data["name"] as? String,
               let avgRating = data["avgRating"] as? Double,
               let location = data["coordinate"] as? GeoPoint {
                
                cafe = Cafe(id: "", name: name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), avgRating: avgRating, reviews: [], images: [])
                
                // Update UI
                cafeView.numberRatingLabel.text = String(format: "%.1f", avgRating)
                cafeView.numReviewsLabel.text = "(\(reviews.count) reviews)"
            }
        }



        @objc func onAddReviewTapped() {
            notificationCenter.post(
                name: Notification.Name("addReview"),
                object: nil,
                userInfo: ["cafe": cafe as Cafe])
        }
    }


    extension CafeViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviews.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviews", for: indexPath) as! ReviewsTableViewCell
            let review = reviews[indexPath.row]
            cell.usernameLabel.text = review.user
            cell.starRating.rating = review.rating
            cell.reviewTitleLabel.text = review.title
            cell.reviewDetailsLabel.text = review.details
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle review selection if needed
        }
    }
