//
//  CustomTabBarViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTabBar()
    }
    
    private func customizeTabBar() {
        
        tabBar.barTintColor = .white
        tabBar.tintColor = K.CoralBright
        
        if let tabBarItems = tabBar.items {
            
            tabBarItems[0].image = UIImage(systemName: "house")
            tabBarItems[0].title = K.Loc.home
            tabBarItems[1].image = UIImage(systemName: "wallet.pass")
            tabBarItems[1].title = K.Loc.offers
            tabBarItems[2].image = UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysOriginal)
            tabBarItems[2].image = tabBarItems[2].image?.withTintColor(.white)
            tabBarItems[3].image = UIImage(systemName: "list.bullet.rectangle.portrait")
            tabBarItems[3].title = K.Loc.history
            tabBarItems[4].image = UIImage(systemName: "person.crop.circle")
            tabBarItems[4].title = K.Loc.account
            
            
            let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            circleView.backgroundColor = K.CoralBright
            circleView.layer.cornerRadius = circleView.frame.width / 2
            circleView.center = CGPoint(x: 0.1, y: 0.2)
            
            tabBar.addSubview(circleView)
            tabBar.sendSubviewToBack(circleView)
            circleView.center = CGPoint(x: tabBar.bounds.width / 2, y: tabBar.bounds.height / 2.5)
        }
    }
}
