//
//  ProfilePageViewController.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import UIKit

class EditProfilePageViewController: UIViewController {
    var currentUser: User!
    var newUser: User!
    
    let editProfilePage = EditProfilePageView()
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = editProfilePage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Set the input field values as the user's current values
        if let currentUser = currentUser {
            editProfilePage.usernameTextField.text = currentUser.username
            editProfilePage.favCafeTextField.text = currentUser.favCafe
            editProfilePage.favDrinkTextField.text = currentUser.favDrink
            newUser = currentUser
        }
        
        editProfilePage.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
                
        //MARK: Hide keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func onSaveButtonTapped() {
        //MARK: post updateUser
        notificationCenter.post(
            name: Notification.Name("updateUser"),
            object: nil,
            userInfo: ["oldUser": currentUser!, "newUser": newUser!])
        
        navigationController?.popViewController(animated: true)
    }

    
    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
}
