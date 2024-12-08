import UIKit

class ReviewsTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
//    var usernameLabel: UILabel! omitting because Review documents contain the user id instead of the username
    var starRating: StarRatingView!
    var reviewTitleLabel: UILabel!
    var reviewDetailsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
//        setupUsernameLabel()
        setupStarRating()
        setupReviewTitleLabel()
        setupReviewDetailsLabel()
        
        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
//    func setupUsernameLabel(){
//        usernameLabel = UILabel()
//        usernameLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(usernameLabel)
//    }
    
    func setupStarRating() {
        starRating = StarRatingView(rating: 3)
        starRating.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(starRating)
    }
    
    func setupReviewTitleLabel(){
        reviewTitleLabel = UILabel()
        reviewTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        reviewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(reviewTitleLabel)
    }
    
    func setupReviewDetailsLabel(){
        reviewDetailsLabel = UILabel()
        reviewDetailsLabel.font = UIFont.systemFont(ofSize: 14)
        reviewDetailsLabel.numberOfLines = 0 // Allow multiple lines
        reviewDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(reviewDetailsLabel)
    }
    
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
//            usernameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 12),
//            usernameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            
            starRating.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 50),
            starRating.topAnchor.constraint(equalTo: wrapperCellView.topAnchor),
            starRating.heightAnchor.constraint(equalToConstant: 20),
            
            reviewTitleLabel.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 15),
            reviewTitleLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            
            reviewDetailsLabel.topAnchor.constraint(equalTo: reviewTitleLabel.bottomAnchor, constant: 4),
            reviewDetailsLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            reviewDetailsLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -12),
            reviewDetailsLabel.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -12),
        ])
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
