//
//  AppCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 19/9/21.
//
import UIKit

class AppCoordinator: Coordinator {
    
    lazy var dataManager: DataManager = {
        let firebaseDataManager = FirebaseDataManagerImp()
        return DataManager(remoteDataManager: firebaseDataManager)
    }()
    
    lazy var userDataManager: UserDataManager = {
        let firebaseUserDataManager = FirebaseUserDataManagerImp()
        return UserDataManager(remoteDataManger: firebaseUserDataManager)
    }()
    
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let tabBarController = UITabBarController()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .primaryColor
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance

        let productsNavigationController = UINavigationController()
        productsNavigationController.isNavigationBarHidden = true
        let productsCoordinator = ProductsCoordinator(presenter: productsNavigationController, userDataManager: userDataManager, productsDataManager: dataManager, productDetailsDataManager: dataManager)
        addChildCoordinator(productsCoordinator)
        productsCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        profileNavigationController.isNavigationBarHidden = true
        let profileCoordinator = ProfileCoordinator(presenter: profileNavigationController, userDataManager: userDataManager, profileDataManager: dataManager, productDetailsDataManager: dataManager)
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
        
        let addProductNavigationController = UINavigationController()
        addProductNavigationController.isNavigationBarHidden = true
        let addProductCoordinator = AddProductCoordinator(presenter: addProductNavigationController, userDataManager: userDataManager, addProductDataManager: dataManager) {
            tabBarController.selectedIndex = 0
            productsCoordinator.reloadProducs()
            profileCoordinator.reloadProducts()
        }
        addChildCoordinator(addProductCoordinator)
        addProductCoordinator.start()
        
        tabBarController.viewControllers = [productsNavigationController, addProductNavigationController, profileNavigationController]
        
        tabBarController.tabBar.items?[0].image = UIImage(named: "icon_home")?.withTintColor(.primaryColor)
        tabBarController.tabBar.items?[0].selectedImage = UIImage(named: "icon_home")?.withTintColor(.accentColor)
        tabBarController.tabBar.items?[0].title = NSLocalizedString("main_tab_bar_products", comment: "")
        
        tabBarController.tabBar.items?[1].image = UIImage(named: "icon_add")?.withTintColor(.primaryColor)
        tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "icon_add")?.withTintColor(.accentColor)
        tabBarController.tabBar.items?[1].title = NSLocalizedString("main_tab_bar_add", comment: "")
        
        tabBarController.tabBar.items?[2].image = UIImage(named: "icon_profile")?.withTintColor(.primaryColor)
        tabBarController.tabBar.items?[2].selectedImage = UIImage(named: "icon_profile")?.withTintColor(.accentColor)
        tabBarController.tabBar.items?[2].title = NSLocalizedString("main_tab_bar_profile", comment: "")
    
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    override func finish() {}
}
