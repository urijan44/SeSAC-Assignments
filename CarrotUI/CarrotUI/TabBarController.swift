//
//  TabBarController.swift
//  CarrotUI
//
//  Created by hoseung Lee on 2021/12/16.
//


import UIKit

class TabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let home = HomeViewController()
    let life = HomeViewController()
    let near = HomeViewController()
    let chat = HomeViewController()
    let mypage = HomeViewController()
    
    home.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
    life.tabBarItem = UITabBarItem(title: "동네생활", image: UIImage(systemName: "doc.on.doc.fill"), tag: 1)
    near.tabBarItem = .init(title: "내 근처", image: .init(systemName: "mappin.and.ellipse"), tag: 2)
    chat.tabBarItem = .init(title: "채팅", image: .init(systemName: "character.bubble"), tag: 3)
    mypage.tabBarItem = .init(title: "나의 당근", image: .init(systemName: "person.fill"), tag: 4)
    
    
    setViewControllers([home, life, near, chat, mypage], animated: false)
    let appearence = UITabBarAppearance()
    appearence.configureWithDefaultBackground()
    appearence.backgroundColor = .white
    appearence.selectionIndicatorTintColor = .black
    
    tabBar.standardAppearance = appearence
    tabBar.scrollEdgeAppearance = appearence
    tabBar.tintColor = .black
    
    
  }
}
