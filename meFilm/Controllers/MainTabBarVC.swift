//
//  MainTabBarVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 7/9/24.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar(){
        //NAVIGATE TAB_BAR
        let homeVC = UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil))
        let discoverVC =  UINavigationController(rootViewController: DiscoverVC(nibName: "DiscoverVC", bundle: nil))
        let userVC = UINavigationController(rootViewController: UserVC(nibName: "UserVC", bundle: nil)
        )
        
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        discoverVC.tabBarItem.image = UIImage(systemName: "play.fill")
        userVC.tabBarItem.image = UIImage(systemName: "person.fill")
        
        UITabBarItem.appearance().badgeColor = UIColor(red: 244.0/255.0, green: 97.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 244.0/255.0, green: 97.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        
        setViewControllers([homeVC, discoverVC, userVC], animated: true)
        
    }
   

}
