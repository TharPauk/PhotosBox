//
//  SignupController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 12/06/2021.
//

import UIKit

class SignupController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageTextView: UITextView!
    @IBOutlet weak var signupButton: RoundedButton!
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        setSignupButtonState(isSigningIn: true)
        
        guard let name = nameTextField.text,
              name.count > 0,
              let email = emailTextField.text,
              email.count > 0,
              let password = passwordTextField.text,
              password.count > 0
        else {
            showError(with: "Text Fields should not be empty!")
            setSignupButtonState(isSigningIn: false)
            return
        }
        
        ApiService.shared.signup(name: name, email: email, password: password,completion: handleSignUp(success:message:))
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    
    
    // MARK: - SignUp State Functions
    
    private func setSignupButtonState(isSigningIn: Bool) {
        nameTextField.isEnabled = !isSigningIn
        emailTextField.isEnabled = !isSigningIn
        passwordTextField.isEnabled = !isSigningIn
        
        let buttonTitle = isSigningIn ? "SIGNING UP": "SIGN UP"
        signupButton.setTitle(buttonTitle, for: .normal)
        signupButton.isEnabled = !isSigningIn
        signupButton.alpha = isSigningIn ? 0.5: 1.0
    }
    
    private func handleSignUp(success: Bool, message: String?) {
        success ? alertSuccess(): showError(with: message!)
        self.setSignupButtonState(isSigningIn: false)
    }
    
    private func showError(with message: String) {
        errorMessageTextView.text = message
        errorMessageTextView.isHidden = false
    }
    
    
    
    // MARK: - Alert Functions
    
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
