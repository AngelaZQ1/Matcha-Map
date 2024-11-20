//
//  RegisterViewController.swift
//  WA8-10
//
//  Created by Angela Zheng on 11/6/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

extension RegisterViewController{
    
    func registerNewAccount() {
            showActivityIndicator()
            
            if let name = registerView.textFieldName.text,
               let email = registerView.textFieldEmail.text,
               let password = registerView.textFieldPassword.text,
               let repeatPassword = registerView.textFieldRepeatPassword.text {
                
                if name.isEmpty || email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
                    showAlert(message: "Please fill in all fields.")
                    hideActivityIndicator()
                    return
                }
                
                if !isValidEmail(email) {
                    showAlert(message: "Please enter a valid email.")
                    hideActivityIndicator()
                    return
                }
                
                if !isValidPassword(password) {
                    showAlert(message: "Password must be at least 6 characters.")
                    hideActivityIndicator()
                    return
                }
                
                if password != repeatPassword {
                    showAlert(message: "Passwords do not match.")
                    hideActivityIndicator()
                    return
                }
                
                // Proceed with Firebase user creation
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error == nil {
                        self.setNameOfTheUserInFirebaseAuth(name: name)
                        let user = User(id: email, name: name, email: email, chats: [])
                        self.saveContactToFireStore(user: user)
                    } else {
                        self.showAlert(message: error?.localizedDescription ?? "Unknown error")
                        self.hideActivityIndicator()
                    }
                }
            }
        }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        
        showActivityIndicator() // Show loading indicator while updating
        
        changeRequest?.commitChanges { error in
            if error == nil {
                // Profile update is successful, now reload the user profile to confirm the update
                Auth.auth().currentUser?.reload { reloadError in
                    // Hide the activity indicator
                    self.hideActivityIndicator()
                    
                    if reloadError == nil {
                        // Successfully reloaded user, pop the view controller
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // Display an alert if reloading user fails
                        self.showAlert(message: "Error reloading user profile: \(reloadError?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                // There was an error updating the profile
                self.hideActivityIndicator()
                self.showAlert(message: "Error updating profile: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    
    //MARK: adds a User to Firestore
    func saveContactToFireStore(user: User){
        // User the email as the document ID in Firestore
        let userDocument = database.collection("users").document(user.email)
        
        //MARK: show progress indicator...
        showActivityIndicator()
        
        // Save user data to Firestore
        do {
            try userDocument.setData(from: user, completion: { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                } else {
                    //MARK: hide progress indicator...
                    self.hideActivityIndicator()
                    
                    // Go back to previous screen
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } catch {
            print("Error serializing user data: \(error.localizedDescription)")
        }
    }
    // MARK: Validates email format using regular expression
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: Validates password length and complexity
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    // MARK: - Alert Helper
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
