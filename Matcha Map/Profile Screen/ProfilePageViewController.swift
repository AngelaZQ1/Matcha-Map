//
//  ProfilePageViewController.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import UIKit

class ProfilePageViewController: UIViewController {
    let profilePage = ProfilePageView()
    var user: User?
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = profilePage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let editProfileButton = UIBarButtonItem(title: "Edit Profile", style: .done, target: self, action: #selector(onEditButtonTapped))
         navigationItem.rightBarButtonItem = editProfileButton
        
        title = "Your Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUser(notification:)), name: Notification.Name("updateUser"), object: nil)

        // Safely unwrap user
       guard let user = user else {
           print("Error: User is nil")
           return
       }
        
        profilePage.username.text = user.username
        profilePage.numReviews.text = "\(String(user.reviews.count)) reviews"
        profilePage.favCafe.text = user.favCafe
        profilePage.favDrink.text = user.favDrink
        // Load profile picture if URL is available
        if let profilePicURLString = user.profilePicURL,
          let profilePicURL = URL(string: profilePicURLString) {
           loadImage(from: profilePicURL) { [weak self] image in
               DispatchQueue.main.async {
                   self?.profilePage.profilePic.image = image
               }
           }
       } else {
           profilePage.profilePic.image = UIImage(systemName: "person.circle") // Placeholder
       }
    }
    
    // MARK: - Load Image from URL
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(url.absoluteString)")
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
    
    // MARK: Show Edit Profile screen
    @objc func onEditButtonTapped(){
        let editProfileVC = EditProfilePageViewController()
        editProfileVC.currentUser = user
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    // MARK: Handle update user
    @objc func handleUpdateUser(notification: Notification) {
        print("update user")
        if let userInfo = notification.userInfo {
            if let newUser = userInfo["newUser"] as? User {
                DispatchQueue.main.async {
                    // Update the profileVC directly
                    self.user = newUser
                    self.profilePage.username.text = newUser.username
                    self.profilePage.numReviews.text = "\(String(newUser.reviews.count)) reviews"
                    self.profilePage.favCafe.text = newUser.favCafe
                    self.profilePage.favDrink.text = newUser.favDrink

                    // Reload the profile image
                    if let profilePicURLString = newUser.profilePicURL,
                       let profilePicURL = URL(string: profilePicURLString) {
                        self.loadImage(from: profilePicURL) { image in
                            self.profilePage.profilePic.image = image
                        }
                    } else {
                        self.profilePage.profilePic.image = UIImage(systemName: "person.circle")
                    }
                }
            }
        }
    }

}
