//
//  SettingsController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 13/06/2021.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passcodeSwitch.isOn = PasscodeService.shared.isPasscodeOn
    }
    
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
    
    private func showPasscodeScreen(with title: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let passcodeController = storyBoard.instantiateViewController(identifier: "PasscodeController") as! PasscodeController
        passcodeController.screenType = .setup
        present(passcodeController, animated: true)
    }
}
