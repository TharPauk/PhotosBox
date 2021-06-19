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
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        setLoginButtonState(isLoggingIn: true)
        guard let email = emailTextField.text,
              email.count > 0,
              let password = passwordTextField.text,
              password.count > 0
        else {
            showError(with: "Text Fields should not be empty!")
            setLoginButtonState(isLoggingIn: false)
            return
        }
        ApiService.shared.login(email: email, password: password,completion: handleLogin(success:message:))
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func setLoginButtonState(isLoggingIn: Bool) {
        emailTextField.isEnabled = !isLoggingIn
        passwordTextField.isEnabled = !isLoggingIn
        
        let buttonTitle = isLoggingIn ? "LOGGING IN": "LOGIN"
        loginButton.setTitle(buttonTitle, for: .normal)
        loginButton.isEnabled = !isLoggingIn
        loginButton.alpha = isLoggingIn ? 0.5: 1.0
    }
    
    
    private func handleLogin(success: Bool, message: String?) {
        success ? alertSuccess(): showError(with: message!)
        setLoginButtonState(isLoggingIn: false)
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
    
    private func showError(with message: String) {
        errorMessageTextView.text = message
        errorMessageTextView.isHidden = false
    }
    
}
