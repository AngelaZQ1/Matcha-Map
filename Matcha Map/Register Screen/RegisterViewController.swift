//
//  RegisterViewController.swift
//  WA8-10
//
//  Created by Angela Zheng on 11/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        registerView.logInInsteadButton.addTarget(self, action: #selector(onSwitchToLogInTapped), for: .touchUpInside)
        
        
        // Hide keybaord when tapped outside
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        registerNewAccount()
    }
    
    @objc func onSwitchToLogInTapped(){
        notificationCenter.post(
            name: Notification.Name("switchToLogIn"),
            object: nil,
            userInfo: nil)
        clearFields()
    }
    
    private func clearFields() {
        registerView.textFieldName.text = ""
        registerView.textFieldEmail.text = ""
        registerView.textFieldPassword.text = ""
        registerView.textFieldRepeatPassword.text = ""
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
}
