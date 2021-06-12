//
//  SignupController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 12/06/2021.
//

import UIKit

class SignupController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageTextView: UITextView!
    @IBOutlet weak var signupButton: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    fileprivate func showError(with message: String) {
        errorMessageTextView.text = message
        errorMessageTextView.isHidden = false
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
        signupButton.setTitle("SIGNING UP", for: .normal)
        signupButton.isEnabled = false
        signupButton.alpha = 0.5
        guard let name = nameTextField.text,
              name.count > 0,
              let email = emailTextField.text,
              email.count > 0,
              let password = passwordTextField.text,
              password.count > 0
        else {
            print("here")
            showError(with: "Text Fields should not be empty!")
            signupButton.setTitle("SIGN UP", for: .normal)
            signupButton.isEnabled = true
            signupButton.alpha = 1
            return
        }
        ApiService.shared.signup(name: name, email: email, password: password) { (success, message)  in
            if success {
                self.alertSuccess()
            } else {
                self.showError(with: message!)
            }
            self.signupButton.setTitle("SIGNUP", for: .normal)
            self.signupButton.isEnabled = true
            self.signupButton.alpha = 1
        }
    }
    
    private func alertSuccess() {
        let alertController = UIAlertController(title: nil, message: "Sign Up Success", preferredStyle: .alert)
        let viewController = self
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            viewController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}
