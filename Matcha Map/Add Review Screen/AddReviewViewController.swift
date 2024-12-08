import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddReviewViewController: UIViewController {
    let addReviewView = AddReviewView()
    let notificationCenter = NotificationCenter.default
    
    var cafe: Cafe! // Passed in when transitioning to this screen
    var db = Firestore.firestore()

    override func loadView() {
        view = addReviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard cafe != nil else {
            print("Error: Cafe is not set.")
            navigationController?.popViewController(animated: true)
            return
        }
        
        // Configure view
        title = "Add a Review"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        addReviewView.overallRatingLabel.text = "0"
                addReviewView.ratingSlider.addTarget(self, action: #selector(onRatingChanged), for: .valueChanged)
                addReviewView.postReviewButton.addTarget(self, action: #selector(onPostReviewTapped), for: .touchUpInside)
        // Hide keyboard when tapping outside of text fields
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onRatingChanged(sender: UISlider) {
            let roundedValue = Int(sender.value.rounded())
            addReviewView.overallRatingLabel.text = "\(roundedValue)"
        }
    
    @objc func onPostReviewTapped() {
        guard let user = Auth.auth().currentUser else {
            print("Error: User not logged in.")
            return
        }
        
        // Retrieve userId from authenticated user
        let userId = user.email
        
        // Validate form inputs
        guard let title = addReviewView.titleTextField.text, !title.isEmpty,
              let details = addReviewView.detailsTextView.text, !details.isEmpty,
              let ratingText = addReviewView.overallRatingLabel.text,
              let rating = Double(ratingText) else {
            print("Error: Missing or invalid inputs.")
            return
        }
        
        // Create the review data
        let reviewData: [String: Any] = [
            "user": userId,
            "cafe": cafe.name,
            "rating": rating,
            "title": title,
            "details": details,
            "images": [] // Add images if available
        ]
       
            
            // Update cafe's average rating and reviews list
            self.updateCafeReviews(with: reviewData)
            
            // Notify other parts of the app that a new review has been added
            self.notificationCenter.post(name: NSNotification.Name("NewReviewAdded"), object: nil)
            
            // Navigate back to the previous screen
            self.navigationController?.popViewController(animated: true)
    }
    
    func updateCafeReviews(with reviewData: [String: Any]) {
        let db = Firestore.firestore()
        
        // Assuming cafe.name is unique, we'll query the cafes collection
        let cafeName = cafe.name
        
        // Query Firestore to find the cafe by its name (or another unique property)
        db.collection("cafes")
            .whereField("name", isEqualTo: cafeName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching cafe: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("Error: Cafe not found")
                    return
                }
                
                // Extract the cafe's id from the document
                let cafeId = document.documentID
                
                // Declare reviewRef outside the closure
                let reviewRef = db.collection("reviews").document()
                
                // Add the review to the reviews collection (separate collection)
                reviewRef.setData(reviewData) { error in
                    if let error = error {
                        print("Error adding review: \(error.localizedDescription)")
                        return
                    }
                    
                    print("Review successfully added")
                    
                    // After adding the review, update the cafe's reviews array with the review ID
                    self.addReviewIdToCafe(cafeId: cafeId, reviewRef: reviewRef)
                    
                    // Optionally, update the cafe's average rating
                    self.updateCafeAverageRating(for: cafeId, db: db)
                }
            }
    }

    func addReviewIdToCafe(cafeId: String, reviewRef: DocumentReference) {
        let db = Firestore.firestore()
        
        // Fetch the existing reviews array from the cafe document
        db.collection("cafes").document(cafeId).getDocument { document, error in
            if let error = error {
                print("Error fetching cafe document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  var reviews = document.data()?["reviews"] as? [String] else {
                print("Error: No reviews field found in cafe document.")
                return
            }
            
            // Add the new review ID to the reviews array
            reviews.append(reviewRef.documentID)
            
            // Update the cafe document with the new reviews array
            db.collection("cafes").document(cafeId).updateData([
                "reviews": reviews
            ]) { error in
                if let error = error {
                    print("Error updating reviews array in cafe document: \(error.localizedDescription)")
                } else {
                    print("Successfully updated reviews array with new review ID")
                }
            }
        }
    }



    func updateCafeAverageRating(for cafeId: String, db: Firestore) {
        // Fetch all reviews for the cafe to calculate the average rating
        db.collection("cafes").document(cafeId).collection("reviews").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reviews to calculate average rating: \(error.localizedDescription)")
                return
            }
            
            let reviews = snapshot?.documents ?? []
            let totalReviews = reviews.count
            var totalRating = 0
            
            for review in reviews {
                if let rating = review.data()["rating"] as? Int {
                    totalRating += rating
                }
            }
            
            let avgRating = totalReviews > 0 ? Double(totalRating) / Double(totalReviews) : 0.0
            
            // Update the cafe's average rating in the document
            db.collection("cafes").document(cafeId).updateData([
                "avgRating": avgRating
            ]) { error in
                if let error = error {
                    print("Error updating cafe's average rating: \(error.localizedDescription)")
                } else {
                    print("Successfully updated cafe's average rating")
                }
            }
        }
    }


    
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}
    
