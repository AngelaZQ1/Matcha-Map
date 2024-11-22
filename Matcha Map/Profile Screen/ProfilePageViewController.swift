//
//  ProfilePageViewController.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/20/24.
//

import Foundation
import UIKit

class ProfilePageViewController: UIViewController {
    let profilePage = ProfilePageView()
    
    override func loadView() {
        view = profilePage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Profile"
        
        profilePage.username.text = "Angela"
        profilePage.numReviews.text = "5 reviews"
        profilePage.favCafe.text = "Test cafe"
        profilePage.favDrink.text = "matcha latte"
    }
    
}
