//
//  LockController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 13/06/2021.
//

import UIKit

enum ScreenType {
    case setup, unlock, confirm
}

class PasscodeController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorMessage: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    
    
    // MARK: - Properties
    
    var screenType: ScreenType!
    private var enteredPin = ""
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCaption()
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func pressedPasscode(_ sender: UIButton) {
        guard let pin = sender.title(for: .normal) else { return }
        
        switch pin {
        case "DEL":
            enteredPin = String(enteredPin.dropLast())
        default:
            enteredPin += pin
        }
        performAction()
    }
    
    
    
    
    // MARK: - Helper Functions
    
    private func setupCaption() {
        switch screenType {
        case .setup:
            titleLabel.text = "Setup Passcode".uppercased()
        case .unlock:
            titleLabel.text = "Enter Passcode".uppercased()
        case .confirm:
            titleLabel.text = "Confirm Passcode".uppercased()
        default:
            break
        }
    }
    
    private func performAction() {
        switch screenType {
        case .setup:
            if enteredPin.count >= 6 {
                PasscodeService.shared.savePasscode(enteredPin)
                self.dismiss(animated: true)
                
            }
        default:
            
            if PasscodeService.shared.passcode == enteredPin {
                self.dismiss(animated: true)
            } else if enteredPin.count > 5 {
                enteredPin = ""
                errorMessage.text = "Incorrect passcode please try again."
                errorMessage.isHidden = false
            }
        }
       
        textField.text = enteredPin
    }
}
