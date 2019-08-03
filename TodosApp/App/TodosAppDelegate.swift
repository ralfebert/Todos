// © 2019 Ralf Ebert — TodosApp

import UIKit

@UIApplicationMain
class TodosAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        window.rootViewController = UINavigationController(rootViewController: TodosTableViewController())
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

}
