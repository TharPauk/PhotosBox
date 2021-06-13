//
//  ViewController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit

class HomeViewController: UITabBarController {
    
    var dataController: DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let navController = self.viewControllers?.first as! UINavigationController
        let photosViewController = navController.viewControllers.first as! PhotosViewController
        photosViewController.dataController = self.dataController
    }
    
    

}

