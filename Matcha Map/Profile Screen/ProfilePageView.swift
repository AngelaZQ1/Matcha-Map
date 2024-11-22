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
    var favCafe: UILabel!
    var favDrink: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupUsername()
        setupNumReviews()
        setupFavCafe()
        setupFavDrink()
        initConstraints()
    }
    
    func setupProfilePic() {
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "photo")
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
    func setupFavCafe(){
        favCafe = UILabel()
        favCafe.font = UIFont.systemFont(ofSize: 18)
        favCafe.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favCafe)
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
            
            favCafe.topAnchor.constraint(equalTo: numReviews.bottomAnchor, constant: 32),
            favCafe.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            favDrink.topAnchor.constraint(equalTo: numReviews.bottomAnchor, constant: 32),
            favDrink.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
