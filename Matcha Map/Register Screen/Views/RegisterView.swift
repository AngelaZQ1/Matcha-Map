//
//  RegisterView.swift
//  App12
//
//  Created by Sakib Miazi on 6/2/23.
//

import UIKit

class RegisterView: UIView {
    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var textFieldRepeatPassword: UITextField!
    var buttonRegister: UIButton!
    var logInInsteadButton:UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setuptextFieldName()
        setuptextFieldEmail()
        setuptextFieldPassword()
        setuptextFieldRepeatPassword()
        setupbuttonRegister()
        setupLogInInsteadButton()
        
        initConstraints()
    }
    
    func setuptextFieldName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Name"
        textFieldName.keyboardType = .default
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setuptextFieldEmail(){
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }
    
    func setuptextFieldPassword(){
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.textContentType = .password
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    
    func setuptextFieldRepeatPassword() {
        textFieldRepeatPassword = UITextField()
        textFieldRepeatPassword.placeholder = "Confirm Password"
        textFieldRepeatPassword.textContentType = .password
        textFieldRepeatPassword.isSecureTextEntry = true
        textFieldRepeatPassword.borderStyle = .roundedRect
        textFieldRepeatPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldRepeatPassword)
    }
    
    func setupbuttonRegister(){
        buttonRegister = UIButton(type: .system)
        buttonRegister.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        buttonRegister.backgroundColor = .blue
        buttonRegister.setTitleColor(.white, for: .normal)
        buttonRegister.layer.cornerRadius = 8
        buttonRegister.clipsToBounds = true
        self.addSubview(buttonRegister)
    }
    
    func setupLogInInsteadButton(){
        logInInsteadButton = UIButton(type: .system)
        logInInsteadButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        logInInsteadButton.setTitle("Log In Instead", for: .normal)
        logInInsteadButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logInInsteadButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            textFieldName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldName.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldRepeatPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16),
            textFieldRepeatPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldRepeatPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            buttonRegister.bottomAnchor.constraint(equalTo: logInInsteadButton.topAnchor, constant: -8),
            buttonRegister.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            buttonRegister.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonRegister.heightAnchor.constraint(equalToConstant: 50),

            logInInsteadButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            logInInsteadButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
