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
        let photosViewNavController = self.viewControllers?.first as! UINavigationController
        let photosViewController = photosViewNavController.viewControllers.first as! PhotosViewController
        photosViewController.dataController = self.dataController
        
        let cloudViewNavController = self.viewControllers?.last as! UINavigationController
        let cloudViewController = cloudViewNavController.viewControllers.first as! CloudViewController
        cloudViewController.dataController = self.dataController
    }
    
    

}

