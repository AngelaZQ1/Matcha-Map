import UIKit

class CafesTableViewCell: UITableViewCell {
    
    private var wrapperCellView: UIView!
    private var labelName: UILabel!
    private var starRatingView: StarRatingView!
    private var ratingLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupStarRatingView()
        setupRatingLabel()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Wrapper for shadow and rounded corners
    private func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    // Cafe name label
    private func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    // Star rating view
    private func setupStarRatingView() {
        starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(starRatingView)
    }
    
    // Avg rating label
    private func setupRatingLabel() {
        ratingLabel = UILabel()
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.textColor = .gray
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(ratingLabel)
    }
    
    // Setup constraints for all subviews
    private func initConstraints() {
        NSLayoutConstraint.activate([
            // Wrapper view constraints
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            // Name label constraints
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(lessThanOrEqualTo: wrapperCellView.trailingAnchor, constant: -16),
            
            // Star rating view constraints
            starRatingView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            starRatingView.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            starRatingView.heightAnchor.constraint(equalToConstant: 20),
            starRatingView.widthAnchor.constraint(equalToConstant: 100), // Adjust width as needed
            
            // Rating label constraints
            ratingLabel.centerYAnchor.constraint(equalTo: starRatingView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starRatingView.trailingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(lessThanOrEqualTo: wrapperCellView.trailingAnchor, constant: -16),
            
            // Wrapper view height constraint
            wrapperCellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    // Configure cell with data
    func configure(with cafe: Place) {
        labelName.text = cafe.title
        let avgRating = Int(cafe.avgRating.rounded()) // Convert to an integer for the star rating
        starRatingView.rating = avgRating
        ratingLabel.text = String(format: "%.1f", cafe.avgRating) // Show the avgRating value
    }
}
