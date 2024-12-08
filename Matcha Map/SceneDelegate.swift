 //
//  SceneDelegate.swift
//  Matcha Map
//
//  Created by Angela Zheng on 11/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create view controllers
        let visitedVC = VisitedCafesViewController()
        let exploreVC = ViewController()
        let profileVC = ProfilePageViewController()

        // Create navigation controllers for each tab
        let visitedNav = UINavigationController(rootViewController: visitedVC)
        let exploreNav = UINavigationController(rootViewController: exploreVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        // Set up tab bar items
        visitedNav.tabBarItem = UITabBarItem(
            title: "Visited",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )

        exploreNav.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )

        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        // Customize tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#71B90D")
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#71B90D")
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#B8B8B8")
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "#B8B8B8")

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Create tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [visitedNav, exploreNav, profileNav]
        tabBarController.selectedIndex = 1 // Set Explore as the default page

        // Set up window
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

// Helper extension for hex color conversion
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
