//
//  PhotoCell.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 06/06/2021.
//

import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    static let identifier = String(describing: PhotoCell.self)
    @IBOutlet weak var imageView: UIImageView!
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.selectItem()
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
    func loadImage(asset: PHAsset, targetSize: CGSize) {
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, _ in
            self.imageView.image = image
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: resultHandler)
    }
    
    func selectItem() {
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
}
