//
//  NavigationController.swift
//  bizzbrains
//
//  Created by Anques on 31/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewControllers.last?.preferredStatusBarStyle ?? .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .primaryColor
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        view.backgroundColor = .primaryColor
    }
    
    func setAppearanceStyle(to style: UIStatusBarStyle) {
        if style == .default {
            navigationBar.shadowImage = UIImage()
            navigationBar.barTintColor = .primaryColor
            navigationBar.tintColor = .white
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        } else if style == .lightContent {
            navigationBar.shadowImage = nil
            navigationBar.barTintColor = .white
            navigationBar.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        }
    }

}

