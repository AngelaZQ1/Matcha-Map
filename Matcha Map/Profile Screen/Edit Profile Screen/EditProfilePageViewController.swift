import Foundation
import UIKit

class EditProfilePageViewController: UIViewController {
    var currentUser: User! // Ensure this is set from the previous view controller
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
            
            // Set the profile image or a default image
            if let profilePicURL = currentUser.profilePicURL, !profilePicURL.isEmpty {
                // Load image from URL
                if let url = URL(string: profilePicURL) {
                    loadImage(from: url)
                }
            } else {
                // Set a default profile image
                editProfilePage.profileImageView.image = UIImage(named: "defaultProfileImage")
            }
        } else {
            // Handle scenario where currentUser is nil
            print("Error: currentUser is nil")
            return
        }
        
        editProfilePage.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        
        //MARK: Hide keyboard when tapping outside of text fields
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func onSaveButtonTapped() {
        // Update the newUser object with the latest text field values
        newUser.username = editProfilePage.usernameTextField.text ?? ""
        newUser.favCafe = editProfilePage.favCafeTextField.text ?? ""
        newUser.favDrink = editProfilePage.favDrinkTextField.text ?? ""

        // Post the updateUser notification
        notificationCenter.post(
            name: Notification.Name("updateUser"),
            object: nil,
            userInfo: ["oldUser": currentUser!, "newUser": newUser!])
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Hide Keyboard on tap outside
    @objc func hideKeyboardOnTap() {
        // Remove the keyboard from the screen
        view.endEditing(true)
    }

    // Helper function to load image from a URL
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.editProfilePage.profileImageView.image = image
                }
            } else {
                print("Failed to load image from URL")
            }
        }
        task.resume()
    }
}
