//
//  AppCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 19/9/21.
//
import UIKit

class AppCoordinator: Coordinator{
    
    lazy var dataManager: DataManager = {
        return DataManager()
    }()
    
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let tabBarController = UITabBarController()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "lightBackground")
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance

        let productsNavigationController = UINavigationController()
        productsNavigationController.isNavigationBarHidden = true
        
        let addProductNavigationController = UINavigationController()
        addProductNavigationController.isNavigationBarHidden = true
        
        let profileNavigationController = UINavigationController()
        profileNavigationController.isNavigationBarHidden = true

        tabBarController.tabBar.tintColor = .primaryColor

        tabBarController.viewControllers = [productsNavigationController, addProductNavigationController, profileNavigationController]
        
        tabBarController.tabBar.items?[0].image = UIImage(named: "icon_home")?.withTintColor(.primaryColor)
        tabBarController.tabBar.items?[0].selectedImage = UIImage(named: "icon_home")?.withTintColor(.accentColor)
        tabBarController.tabBar.items?[0].title = NSLocalizedString("Productos", comment: "")
        
        tabBarController.tabBar.items?[1].image = UIImage(named: "icon_add")?.withTintColor(.primaryColor)
        tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "icon_add")?.withTintColor(.accentColor)
        tabBarController.tabBar.items?[1].title = NSLocalizedString("Añadir", comment: "")
        
        tabBarController.tabBar.items?[2].image = UIImage(named: "icon_profile")?.withTintColor(.primaryColor)
        tabBarController.tabBar.items?[2].selectedImage = UIImage(named: "icon_profile")?.withTintColor(.accentColor)
        tabBarController.tabBar.items?[2].title = NSLocalizedString("Perfil", comment: "")
    
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    override func finish() {}
    
}
