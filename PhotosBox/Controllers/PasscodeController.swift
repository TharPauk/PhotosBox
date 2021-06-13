//
//  LockController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 13/06/2021.
//

import UIKit

class PasscodeController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    private var enteredPin = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedPasscode(_ sender: UIButton) {
        guard let pin = sender.title(for: .normal) else { return }
        
        switch pin {
        case "DEL":
            enteredPin = String(enteredPin.dropLast())
        default:
            enteredPin += pin
        }
        
        textField.text = enteredPin
    }
}
