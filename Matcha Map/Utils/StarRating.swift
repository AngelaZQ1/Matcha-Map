//
//  StarRating.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/25/24.
//

import UIKit

class StarRatingView: UIView {
    
    // Public property to set the rating
    var rating: Int = 0 {
        didSet {
            updateStars()
        }
    }
    
    // Array to hold the star UIImageViews
    private var starImageViews: [UIImageView] = []
    
    // Initializer with custom rating
    convenience init(rating: Int) {
        self.init(frame: .zero) // Calls the designated initializer
        self.rating = rating
        updateStars() // Ensure stars reflect the initial rating
    }
    
    // Designated initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }
    
    // Create and add stars to the view
    private func setupStars() {
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray // Default color for gray stars
            imageView.image = UIImage(systemName: "star") // Use SF Symbol
            starImageViews.append(imageView)
            addSubview(imageView)
        }
    }
    
    // Update stars based on the rating
    private func updateStars() {
        for (index, imageView) in starImageViews.enumerated() {
            imageView.image = UIImage(systemName: index < rating ? "star.fill" : "star")
            imageView.tintColor = index < rating ? .systemYellow : .gray // Yellow for filled stars
        }
    }
    
    // Layout the stars evenly
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let starSize = bounds.height // Keep stars square
        let spacing: CGFloat = 1 // Spacing between stars
        let totalWidth = (starSize * 5) + (spacing * 4)
        let startX = (bounds.width - totalWidth) / 2
        
        for (index, imageView) in starImageViews.enumerated() {
            let xPosition = startX + CGFloat(index) * (starSize + spacing)
            imageView.frame = CGRect(x: xPosition, y: 0, width: starSize, height: starSize)
        }
    }
}
