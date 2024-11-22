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
        
        title = "Your Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        profilePage.username.text = user!.username
        profilePage.numReviews.text = "\(String(user!.reviews.count)) reviews"
        profilePage.favCafe.text = user!.favCafe
        profilePage.favDrink.text = user!.favDrink
        
        let editProfileButton = UIBarButtonItem(title: "Edit Profile", style: .done, target: self, action: #selector(onEditButtonTapped))
        navigationItem.rightBarButtonItem = editProfileButton
        
        //MARK: Observe Save Changes
        notificationCenter.addObserver(
            self,
            selector: #selector(handleUpdateUser(notification:)),
            name: Notification.Name("updateUser"),
            object: nil)
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
    }
}
