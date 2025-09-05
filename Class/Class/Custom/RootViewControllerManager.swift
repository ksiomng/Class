//
//  RootViewControllerManager.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit

final class RootViewControllerManager {
    private init() { }
    
    static func getRootViewController() -> UIViewController {
        if UserDefaultsHelper.shared.checkLogin() {
            let homeVC = UINavigationController(rootViewController: HomeViewController())
            homeVC.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(systemName: "house.fill"), tag: 0)
            
            let searchVC = UINavigationController(rootViewController: SearchViewController())
            searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
            
            let profileVC = UINavigationController(rootViewController: ProfileViewController())
            profileVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person.crop.circle"), tag: 2)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [homeVC, searchVC, profileVC]
            tabBarController.tabBar.backgroundColor = .white
            tabBarController.tabBar.tintColor = .darkGrayC
            tabBarController.tabBar.barTintColor = .lightGrayC
            return tabBarController
        } else {
            return LogInViewController()
        }
    }
}
