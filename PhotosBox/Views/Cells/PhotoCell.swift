//
//  PhotoCell.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 06/06/2021.
//

import UIKit
import Photos

class PhotoCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
    
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
        
        createContextMenu()
    }
    
    private func createContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    func loadImage(asset: PHAsset, targetSize: CGSize) {
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, _ in
            self.imageView.image = image
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: resultHandler)
    }
    
    func selectItem() {
        self.imageView.alpha = 0.6
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let inspectAction =
                UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                         image: UIImage(systemName: "arrow.up.square")) { action in
//                    self.performInspect()
                }
                
            let duplicateAction =
                UIAction(title: NSLocalizedString("Save", comment: ""),
                         image: UIImage(systemName: "plus.square.on.square")) { action in
//                    self.performDuplicate()
                }
                
            let deleteAction =
                UIAction(title: NSLocalizedString("Delete", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
//                    self.performDelete()
                }
                                            
            return UIMenu(title: "Actions", children: [duplicateAction, deleteAction])
        })
    }
    
}
