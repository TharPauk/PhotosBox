//
//  SettingsController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 13/06/2021.
//

import UIKit

class SettingsController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var logoutButton: RoundedButton!
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passcodeSwitch.isOn = PasscodeService.shared.isPasscodeOn
        logoutButton.isHidden = !AuthService.shared.isLoggedIn
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if !PasscodeService.shared.isPasscodeOn {
            showPasscodeScreen(with: "Setup Passcode")
        } else {
            PasscodeService.shared.savePasscode(nil)
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        AuthService.shared.removeLoginUser()
        self.dismiss(animated: true)
    }
    
    
    
    // MARK: - Passcode
    
    private func showPasscodeScreen(with title: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let passcodeController = storyBoard.instantiateViewController(identifier: "PasscodeController") as! PasscodeController
        passcodeController.screenType = .setup
        present(passcodeController, animated: true)
    }
}
