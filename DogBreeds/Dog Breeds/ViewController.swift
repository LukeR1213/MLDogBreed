//
//  ViewController.swift
//  Dog Breeds
//
//  Created by Jaden Banson on 2019-02-02.
//  Copyright © 2019 Jaden Banson. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class ViewController: SwipeableTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = identifiedDogs()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let secondViewController = identifyView()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        
        let tabBarList = [firstViewController, secondViewController]
        viewControllers = tabBarList
        
        selectedViewController = viewControllers![0]
    }


}

