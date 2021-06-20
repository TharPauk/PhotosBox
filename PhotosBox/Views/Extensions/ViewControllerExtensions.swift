//
//  ViewControllerExtensions.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 20/06/2021.
//

import UIKit

extension UIViewController {

    func popupMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

}
