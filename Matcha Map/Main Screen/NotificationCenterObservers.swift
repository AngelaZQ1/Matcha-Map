//
//  NotificationCenterObservers.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/23/24.
//

import Foundation

extension ViewController {
    
    func addNotificationCenterObservers() {
        notificationCenter.addObserver(
            self,
            selector: #selector(handleLogIn(_:)),
            name: Notification.Name("logIn"),
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(handleSignUp(_:)),
            name: Notification.Name("signUp"),
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(handleSwitchToLogIn(_:)),
            name: Notification.Name("switchToLogIn"),
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(handleSwitchToRegister(_:)),
            name: Notification.Name("switchToRegister"),
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(handleAddReview(_:)),
            name: Notification.Name("addReview"),
            object: nil
        )
    }
    
    @objc private func handleLogIn(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let email = userInfo["email"], let password = userInfo["password"] {
            print("handleLogIn")
        }
    }
    @objc private func handleSignUp(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let username = userInfo["username"],
           let email = userInfo["email"],
           let password = userInfo["password"] {
            print("handleSignUp")
        }
    }
    @objc private func handleSwitchToLogIn(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
        let logInVC = LogInViewController()
        self.navigationController?.pushViewController(logInVC, animated: true)
    }
    @objc private func handleSwitchToRegister(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @objc private func handleAddReview(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let cafe = userInfo["cafe"]{
            print("cafe", cafe)
            let addReviewVC = AddReviewViewController()
            addReviewVC.cafe = cafe as! Cafe
            self.navigationController?.pushViewController(addReviewVC, animated: true)
        }
    }
}
