//
//  MainScreenView.swift
//  App11
//
//  Created by Sakib Miazi on 5/26/23.
//

import UIKit

class AddReviewView: UIView {
    var overallRatingLabel: UILabel!
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    var detailsLabel: UILabel!
    var detailsTextView: UITextView!
    var postReviewButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupOverallRatingLabel()
        setupTitleLabel()
        setupTitleTextField()
        setupDetailsLabel()
        setupDetailsTextView()
        setupPostReviewButton()
        
        initConstraints()
    }
    func setupOverallRatingLabel(){
        overallRatingLabel = UILabel()
        overallRatingLabel.font = UIFont.systemFont(ofSize: 18)
        overallRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overallRatingLabel)
    }
    func setupTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "Give your review a title:"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    func setupTitleTextField(){
        titleTextField = UITextField()
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleTextField)
    }
    func setupDetailsLabel(){
        detailsLabel = UILabel()
        detailsLabel.text = "Add some more details.."
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailsLabel)
    }
    func setupDetailsTextView(){
        detailsTextView = UITextView()
        detailsTextView.isScrollEnabled = false // Allow the height to expand with content
        detailsTextView.layer.borderWidth = 1
        detailsTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        detailsTextView.layer.cornerRadius = 7
        detailsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailsTextView)
    }
    func setupPostReviewButton(){
        postReviewButton = UIButton(type: .system)
        postReviewButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        postReviewButton.setTitle("Post Review", for: .normal)
        postReviewButton.translatesAutoresizingMaskIntoConstraints = false
        postReviewButton.backgroundColor = .blue
        postReviewButton.setTitleColor(.white, for: .normal)
        postReviewButton.layer.cornerRadius = 8
        postReviewButton.clipsToBounds = true
        self.addSubview(postReviewButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            overallRatingLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            overallRatingLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: overallRatingLabel.bottomAnchor, constant: 32),
            
            titleTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            detailsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            detailsLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            
            detailsTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            detailsTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            detailsTextView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            detailsTextView.heightAnchor.constraint(equalToConstant: 200),
            
            postReviewButton.topAnchor.constraint(equalTo: detailsTextView.bottomAnchor, constant: 70),
            postReviewButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            postReviewButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            postReviewButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
