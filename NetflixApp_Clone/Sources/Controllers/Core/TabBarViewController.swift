//
//  TabBarViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupTabBar()
    }

    func setupTabBar() {

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())

        let homeVcIcon = UITabBarItem(title: "Home",
                                      image: UIImage(systemName: "house"),
                                      selectedImage: UIImage(systemName: "house"))
        homeVC.tabBarItem = homeVcIcon

        let upcomingVcIcon = UITabBarItem(title: "Coming Soon",
                                          image: UIImage(systemName: "play.circle"),
                                          selectedImage: UIImage(systemName: "play.circle"))
        upcomingVC.tabBarItem = upcomingVcIcon

        let searchVcIcon = UITabBarItem(title: "Top Search",
                                        image: UIImage(systemName: "magnifyingglass"),
                                        selectedImage: UIImage(systemName: "magnifyingglass"))
        searchVC.tabBarItem = searchVcIcon

        let downloadsVcIcon = UITabBarItem(title: "Downloads",
                                           image: UIImage(systemName: "arrow.down.to.line"),
                                           selectedImage: UIImage(systemName: "arrow.down.to.line"))
        downloadsVC.tabBarItem = downloadsVcIcon

        let viewControllers = [homeVC, upcomingVC, searchVC, downloadsVC]
        setViewControllers(viewControllers, animated: true)
        tabBar.tintColor = .label
    }
}
