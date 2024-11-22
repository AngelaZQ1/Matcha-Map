//
//  ProfilePageView.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import UIKit

class EditProfilePageView: UIView {
    var usernameLabel: UILabel!
    var usernameTextField: UITextField!
    var favCafeLabel: UILabel!
    var favCafeTextField: UITextField!
    var favDrinkLabel: UILabel!
    var favDrinkTextField: UITextField!
    var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupUsernameLabel()
        setupUsernameTextField()
        setupFavCafeLabel()
        setupFavCafeTextField()
        setupFavDrinkLabel()
        setupFavDrinkTextField()
        setupSaveButton()
        initConstraints()
    }
    
    func setupUsernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.text = "Username"
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameLabel)
    }
    func setupUsernameTextField() {
        usernameTextField = UITextField()
        usernameTextField.placeholder = "JohnDoe123"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameTextField)
    }
    func setupFavCafeLabel(){
        favCafeLabel = UILabel()
        favCafeLabel.text = "Favorite Cafe"
        favCafeLabel.font = UIFont.systemFont(ofSize: 14)
        favCafeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favCafeLabel)
    }
    func setupFavCafeTextField(){
        favCafeTextField = UITextField()
        favCafeTextField.placeholder = "Matcha Maiko"
        favCafeTextField.borderStyle = .roundedRect
        favCafeTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favCafeTextField)
    }
    func setupFavDrinkLabel() {
        favDrinkLabel = UILabel()
        favDrinkLabel.text = "Favorite Drink"
        favDrinkLabel.font = UIFont.systemFont(ofSize: 14)
        favDrinkLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favDrinkLabel)
    }
    func setupFavDrinkTextField() {
        favDrinkTextField = UITextField()
        favDrinkTextField.placeholder = "White Peach Matcha Latte"
        favDrinkTextField.borderStyle = .roundedRect
        favDrinkTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favDrinkTextField)
    }
    func setupSaveButton() {
        saveButton = UIButton(type: .system)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .blue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.layer.cornerRadius = 8
        saveButton.clipsToBounds = true
        self.addSubview(saveButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            usernameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usernameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),

            favCafeLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            favCafeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            favCafeTextField.topAnchor.constraint(equalTo: favCafeLabel.bottomAnchor, constant: 8),
            favCafeTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            favCafeTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            favCafeTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            favCafeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            favDrinkLabel.topAnchor.constraint(equalTo: favCafeTextField.bottomAnchor, constant: 16),
            favDrinkLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            favDrinkTextField.topAnchor.constraint(equalTo: favDrinkLabel.bottomAnchor, constant: 8),
            favDrinkTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            favDrinkTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            favDrinkTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            favDrinkTextField.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            saveButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
