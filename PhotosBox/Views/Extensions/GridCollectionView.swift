//
//  GridCollectionView.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 07/06/2021.
//

import UIKit

class GridCollectionView: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var cellWidth: CGFloat {
        (view.frame.width - 10) / 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
}
