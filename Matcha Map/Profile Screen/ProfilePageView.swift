import UIKit

class ProfilePageView: UIView {
    var profilePic: UIImageView!
    var username: UILabel!
    var numReviews: UILabel!
    var favCafeLabel: UILabel!
    var favCafe: UILabel!
    var favDrinkLabel: UILabel!
    var favDrink: UILabel!
    
    // Add a property to store the profile image URL (as a String)
    var profileImageURLString: String?
    
    // Default image to use if profilePicURL is nil or invalid
    let defaultImage = UIImage(systemName: "photo")  // Default image (System icon)
    
    // Default initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    // Modify the initializer to accept the profile image URL string
    init(frame: CGRect, profileImageURLString: String?) {
        self.profileImageURLString = profileImageURLString  // Set the passed image URL string
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupUsername()
        setupNumReviews()
        setupFavCafeLabel()
        setupFavCafe()
        setupFavDrinkLabel()
        setupFavDrink()
        initConstraints()
        
        // Load the profile image from the URL string
        loadProfileImage()
    }
    
    func setupProfilePic() {
        profilePic = UIImageView()
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = 10
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupUsername() {
        username = UILabel()
        username.font = UIFont.boldSystemFont(ofSize: 24)
        username.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(username)
    }
    
    func setupNumReviews() {
        numReviews = UILabel()
        numReviews.font = UIFont.systemFont(ofSize: 18)
        numReviews.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(numReviews)
    }
    
    func setupFavCafeLabel() {
        favCafeLabel = UILabel()
        favCafeLabel.text = "Favorite Cafe"
        favCafeLabel.font = UIFont.systemFont(ofSize: 18)
        favCafeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favCafeLabel)
    }
    
    func setupFavCafe() {
        favCafe = UILabel()
        favCafe.font = UIFont.systemFont(ofSize: 18)
        favCafe.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favCafe)
    }
    
    func setupFavDrinkLabel() {
        favDrinkLabel = UILabel()
        favDrinkLabel.text = "Favorite Drink"
        favDrinkLabel.font = UIFont.systemFont(ofSize: 18)
        favDrinkLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favDrinkLabel)
    }
    
    func setupFavDrink() {
        favDrink = UILabel()
        favDrink.font = UIFont.systemFont(ofSize: 18)
        favDrink.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favDrink)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePic.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            username.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 16),
            username.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            numReviews.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 16),
            numReviews.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            favCafeLabel.topAnchor.constraint(equalTo: numReviews.bottomAnchor, constant: 64),
            favCafeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            favCafe.leadingAnchor.constraint(equalTo: favCafeLabel.leadingAnchor),
            favCafe.topAnchor.constraint(equalTo: favCafeLabel.bottomAnchor, constant: 8),
            
            favDrinkLabel.leadingAnchor.constraint(equalTo: favCafeLabel.leadingAnchor),
            favDrinkLabel.topAnchor.constraint(equalTo: favCafe.bottomAnchor, constant: 32),
            
            favDrink.topAnchor.constraint(equalTo: favDrinkLabel.bottomAnchor, constant: 8),
            favDrink.leadingAnchor.constraint(equalTo: favCafeLabel.leadingAnchor),
        ])
    }
    
    // Load the profile image from the URL string asynchronously
    func loadProfileImage() {
        // Use default image if profileImageURLString is nil or invalid
        if let urlString = profileImageURLString, let url = URL(string: urlString) {
            // If the URL is valid, fetch the image from the URL
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error loading image from URL: \(String(describing: error))")
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.profilePic.image = image
                    } else {
                        self?.profilePic.image = self?.defaultImage
                    }
                }
            }.resume()
        } else {
            // Use default image if the URL is invalid or nil
            profilePic.image = defaultImage
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
