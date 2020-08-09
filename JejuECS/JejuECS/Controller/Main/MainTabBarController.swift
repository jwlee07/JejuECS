//
//  MainTabBarController.swift
//  JejuECS
//
//  Created by 윤병일 on 2020/08/07.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController {
  
  //MARK: - viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let homeVC = HomeViewController()
    homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
    let homeNavi = UINavigationController(rootViewController: homeVC)
    
    let searchVC = SearchViewController()
    searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    let searchNavi = UINavigationController(rootViewController: searchVC)
    
    let guideVC = GuideViewController()
    guideVC.tabBarItem = UITabBarItem(title: "가이드", image: UIImage(systemName: "pencil"), tag: 2)
    let guideNavi = UINavigationController(rootViewController: guideVC)
    
    let myPageVC = MyPageViewController()
    myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 2)
    let myPageNavi = UINavigationController(rootViewController: myPageVC)
    
    viewControllers = [homeNavi, searchNavi , guideNavi , myPageNavi]
  }
}
