//
//  MyTabBarController.swift
//  My Locations
//
//  Created by Andrey Demidov on 24/07/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
