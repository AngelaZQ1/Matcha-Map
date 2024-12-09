import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit
class ViewController: UITabBarController {

    private var currentUser: FirebaseAuth.User?
    private let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    func setupViewControllers() {
        // Create the visited, explore, and profile view controllers
        let visitedVC = VisitedCafesViewController()
        visitedVC.view.backgroundColor = .white
        visitedVC.tabBarItem = UITabBarItem(title: "Visited", image: UIImage(systemName: "checkmark.circle"), selectedImage: UIImage(systemName: "checkmark.circle.fill"))

        let exploreVC = ExploreViewController() // The Explore screen (this will be the current VC)
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        let profileVC = ProfilePageViewController()
        // needed for the title and "edit profile" buttons to show up
        let profileNavVC = UINavigationController(rootViewController: profileVC)


        // Fetch user data and set it to the profileVC
        ApiCalls().fetchUserFromFirestore { user in
            DispatchQueue.main.async {
                profileVC.user = user // Pass the fetched user here
                profileVC.view.backgroundColor = .white
                profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
                
                // Create tabBarController after setting the profileVC
                self.viewControllers = [visitedVC, exploreVC, profileNavVC]
                self.selectedViewController = exploreVC // Make sure the Explore VC is selected initially
                self.tabBar.tintColor = .systemGreen
                self.tabBar.unselectedItemTintColor = .gray
            }
        }
    }
}
