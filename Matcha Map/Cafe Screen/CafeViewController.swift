import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class CafeViewController: UIViewController {
    let cafeView = CafeView()
    let notificationCenter = NotificationCenter.default
    let db = Firestore.firestore() // Firestore instance
    
    var cafe: Cafe!
    var reviews = [Review]()
    
    override func loadView() {
        view = cafeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = cafe.name ?? "Cafe Details"
        self.fetchReviews(for: cafe.id ?? "")
        
        cafeView.reviewsTableView.dataSource = self
        cafeView.reviewsTableView.delegate = self
        cafeView.cafeNameLabel.text = cafe.name
        cafeView.numReviewsLabel.text = "\(cafe.reviews?.count ?? 0) reviews"
        cafeView.numberRatingLabel.text = "\(cafe.avgRating)"
        
        // Set the visited status button
        updateVisitedButton()

        // Add button action for adding reviews
        cafeView.addReviewButton.addTarget(self, action: #selector(onAddReviewTapped), for: .touchUpInside)
        cafeView.visitedButton.addTarget(self, action: #selector(onVisitedButtonTapped), for: .touchUpInside)
        
        notificationCenter.addObserver(self, selector: #selector(reloadReviewsTable(_:)), name: Notification.Name("newReviewAdded"), object: nil)
    }

    private func updateVisitedButton() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No user logged in")
            return
        }
        
        let userRef = db.collection("users").document(currentUserEmail)
        
        // Check if the cafe is in the visited list for the user
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            // Get the visited cafes list
            if let visitedCafes = document.data()?["visitedCafes"] as? [String] {
                if visitedCafes.contains(self.cafe.id ?? "") {
                    self.cafeView.visitedButton.setTitle("Visited", for: .normal)
                    self.cafeView.visitedButton.backgroundColor = .green
                } else {
                    self.cafeView.visitedButton.setTitle("Not Visited", for: .normal)
                    self.cafeView.visitedButton.backgroundColor = .blue
                }
            }
        }
    }

    @objc func onVisitedButtonTapped() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No user logged in")
            return
        }
        
        let userRef = db.collection("users").document(currentUserEmail)
        
        // Check if the cafe is already in the visited list
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            // Get the visited cafes list
            if var visitedCafes = document.data()?["visitedCafes"] as? [String] {
                if visitedCafes.contains(self.cafe.id ?? "") {
                    // Remove cafe from visited list
                    visitedCafes.removeAll { $0 == self.cafe.id }
                    
                    userRef.updateData([
                        "visitedCafes": visitedCafes
                    ]) { error in
                        if let error = error {
                            print("Error removing cafe from visited list: \(error.localizedDescription)")
                        } else {
                            // Update UI and change button title to Not Visited
                            self.updateVisitedButton()
                        }
                    }
                } else {
                    // Add cafe to visited list
                    visitedCafes.append(self.cafe.id ?? "")
                    
                    userRef.updateData([
                        "visitedCafes": visitedCafes
                    ]) { error in
                        if let error = error {
                            print("Error adding cafe to visited list: \(error.localizedDescription)")
                        } else {
                            // Update UI and change button title to Visited
                            self.updateVisitedButton()
                        }
                    }
                }
            }
        }
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

    @objc func onAddReviewTapped() {
        notificationCenter.post(
            name: Notification.Name("addReviewTapped"),
            object: nil,
            userInfo: ["cafe": cafe as Cafe])
    }
    
    @objc func reloadReviewsTable(_ notification: Notification) {
        self.fetchReviews(for: cafe.id ?? "")
    }
}


extension CafeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviews", for: indexPath) as! ReviewsTableViewCell
        let review = reviews[indexPath.row]
        cell.starRating.rating = review.rating
        cell.reviewTitleLabel.text = review.title
        cell.reviewDetailsLabel.text = review.details
        return cell
    }
}
