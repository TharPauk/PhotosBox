//
//  PhotoDetailController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 07/06/2021.
//

import UIKit

class PhotoDetailController: UIViewController {

    
    @IBOutlet weak var photoView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoView.image = image
    }
    

}
