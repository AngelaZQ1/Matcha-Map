//
//  ProfilePageView.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import UIKit

class ProfilePageView: UIView {
    var profilePic: UIImageView!
    var username: UILabel!
    var numReviews: UILabel!
    var favCafeLabel: UILabel!
    var favCafe: UILabel!
    var favDrinkLabel: UILabel!
    var favDrink: UILabel!
    
    override init(frame: CGRect) {
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
    func setupNumReviews(){
        numReviews = UILabel()
        numReviews.font = UIFont.systemFont(ofSize: 18)
        numReviews.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(numReviews)
    }
    func setupFavCafeLabel(){
        favCafeLabel = UILabel()
        favCafeLabel.text = "Favorite Cafe"
        favCafeLabel.font = UIFont.systemFont(ofSize: 18)
        favCafeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favCafeLabel)
    }
    func setupFavCafe(){
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
    
    func initConstraints(){
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
