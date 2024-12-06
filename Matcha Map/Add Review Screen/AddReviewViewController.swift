//
//  SignUpViewController.swift
//  App11
//
//  Created by Angela Zheng on 10/28/24.
//

import UIKit

class AddReviewViewController: UIViewController {
    let addReviewView = AddReviewView()
    let notificationCenter = NotificationCenter.default
    
    var cafe: Cafe!
    
    override func loadView() {
        view = addReviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a Review"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        addReviewView.overallRatingLabel.text = "How would you rate \(cafe.name) overall?"
        
        addReviewView.postReviewButton.addTarget(self, action: #selector(onPostReviewTapped), for: .touchUpInside)
        
        //MARK: Hide keyboard when tapping outside of text fields
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onPostReviewTapped() {
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Hide Keyboard on tap outside
    @objc func hideKeyboardOnTap() {
        // Remove the keyboard from the screen
        view.endEditing(true)
    }
}
