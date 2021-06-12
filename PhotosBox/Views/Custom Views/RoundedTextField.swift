//
//  RoundedTextField.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 11/06/2021.
//

import UIKit

@IBDesignable class RoundedTextField: UITextField {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = .lightGray {
        didSet {
            guard let placeholderText = self.placeholder else { return }
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        }
    }
    
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
