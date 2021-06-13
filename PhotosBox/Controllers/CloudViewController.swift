//
//  CloudViewController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit

class CloudViewController: UIViewController {
    
    
    @IBOutlet weak var loginSection: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginSection.isHidden = AuthService.shared.isLoggedIn
    }
    
  
}
