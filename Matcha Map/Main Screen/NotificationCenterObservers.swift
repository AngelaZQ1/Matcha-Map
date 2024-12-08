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
            selector: #selector(handleShowAddReviewScreen(_:)),
            name: Notification.Name("addReviewTapped"),
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(handleViewCafe(_:)),
            name: Notification.Name("viewCafe"),
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
    @objc private func handleShowAddReviewScreen(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let cafe = userInfo["cafe"]{
            let addReviewVC = AddReviewViewController()
            addReviewVC.cafe = cafe as! Cafe
            self.navigationController?.pushViewController(addReviewVC, animated: true)
        }
    }
    @objc private func handleViewCafe(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let cafeName = userInfo["cafeName"] {
            let api = ApiCalls()
            api.getCafeByName(cafeName as! String) { result in
                switch result {
                case .success(let cafe):
                    let cafeVC = CafeViewController()
                    cafeVC.cafe = cafe
                    self.navigationController?.pushViewController(cafeVC, animated: true)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
