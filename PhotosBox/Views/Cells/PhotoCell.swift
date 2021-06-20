//
//  PhotoCell.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 06/06/2021.
//

import UIKit
import Photos
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    static let identifier = String(describing: PhotoCell.self)
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.selectItem()
            } else {
                self.layer.borderWidth = 0
                self.imageView.alpha = 1.0
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func loadImage(asset: PHAsset, targetSize: CGSize) {
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, _ in
            self.imageView.image = image
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: resultHandler)
    }
    
    func requestImage(urlString: String) {
        let url = URL(string: urlString)
        imageView.sd_setImage(with: url)
    }
    
    func selectItem() {
        self.imageView.alpha = 0.6
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    
    
}
