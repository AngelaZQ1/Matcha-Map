//
//  SignUpViewController.swift
//  App11
//
//  Created by Angela Zheng on 10/28/24.
//

import UIKit

class LogInViewController: UIViewController {
    let logInView = LogInView()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = logInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        
        logInView.logInButton.addTarget(self, action: #selector(onLogInTapped), for: .touchUpInside)
        logInView.signUpInsteadButton.addTarget(self, action: #selector(onSwitchToSignUpTapped), for: .touchUpInside)
    }
    
    @objc func onLogInTapped() {
        notificationCenter.post(
            name: Notification.Name("logIn"),
            object: nil,
            userInfo: ["email": logInView.emailField.text!, "password": logInView.passwordField.text!])
        clearFields()
    }
    
    @objc func onSwitchToSignUpTapped() {
        notificationCenter.post(
            name: Notification.Name("switchToRegister"),
            object: nil,
            userInfo: nil)
        clearFields()
    }
    
    private func clearFields() {
        logInView.emailField.text = ""
        logInView.passwordField.text = ""
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
