//
//  MainScreenView.swift
//  App11
//
//  Created by Sakib Miazi on 5/26/23.
//

import UIKit

class LogInView: UIView {
    var emailField:UITextField!
    var passwordField:UITextField!
    var logInButton:UIButton!
    var signUpInsteadButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupEmailField()
        setupPasswordField()
        setupLogInButton()
        setupSignUpInsteadButton()
        
        initConstraints()
    }
    func setupEmailField(){
        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailField)
    }
    func setupPasswordField(){
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordField)
    }
    func setupLogInButton(){
        logInButton = UIButton(type: .system)
        logInButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.backgroundColor = .blue
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.layer.cornerRadius = 8
        logInButton.clipsToBounds = true
        self.addSubview(logInButton)
    }
    func setupSignUpInsteadButton(){
        signUpInsteadButton = UIButton(type: .system)
        signUpInsteadButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        signUpInsteadButton.setTitle("Create an account instead", for: .normal)
        signUpInsteadButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signUpInsteadButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -8),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -16),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            logInButton.bottomAnchor.constraint(equalTo: signUpInsteadButton.topAnchor, constant: -8),
            logInButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),

            signUpInsteadButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signUpInsteadButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            signUpInsteadButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
        ])
    }
    
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
