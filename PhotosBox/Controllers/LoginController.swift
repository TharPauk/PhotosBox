//
//  LoginController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 12/06/2021.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageTextView: UITextView!
    @IBOutlet weak var loginButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func showError(with message: String) {
        errorMessageTextView.text = message
        errorMessageTextView.isHidden = false
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        loginButton.setTitle("LOGGING IN", for: .normal)
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        guard let email = emailTextField.text,
              email.count > 0,
              let password = passwordTextField.text,
              password.count > 0
        else {
            print("here")
            showError(with: "Text Fields should not be empty!")
            loginButton.setTitle("LOGIN", for: .normal)
            loginButton.isEnabled = true
            loginButton.alpha = 1
            return
        }
        ApiService.shared.login(email: email, password: password) { (success, message)  in
            if success {
                self.alertSuccess()
            } else {
                self.showError(with: message!)
            }
            self.loginButton.setTitle("LOGIN", for: .normal)
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1
        }
    }
    
    private func alertSuccess() {
        let alertController = UIAlertController(title: nil, message: "Login Success", preferredStyle: .alert)
        let viewController = self
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            viewController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
