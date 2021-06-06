//
//  PhotosController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit
import Photos

class PhotosViewController: UIViewController {
    
    private var photos = PHFetchResult<PHAsset>()
    private var cellWidth: CGFloat {
        (view.frame.width - 10) / 3
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        requestPermission()
        loadPhotos()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.minimumInteritemSpacing = 2.0
    }
    
    private func requestPermission() {
        guard PHPhotoLibrary.authorizationStatus() != .authorized
        else { return }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.collectionView.reloadData()
            } else {
                self.goToSettingsAlert()
            }
        }
        
    }
    
    private func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photos = PHAsset.fetchAssets(with: options)
        collectionView.reloadData()
    }
    
    private func goToSettingsAlert() {
        let alertVC = UIAlertController(title: "Photo Permission is not granted.", message: "Allow Photos Access in the Settings to select photos.", preferredStyle: .alert)
        let goToSettingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        [goToSettingsAction, cancelAction].forEach { alertVC.addAction($0) }
        alertVC.preferredAction = goToSettingsAction
        present(alertVC, animated: true)
    }
}


extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
}


extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let asset = photos[indexPath.item]
        cell.loadImage(asset: asset, targetSize: CGSize(width: cellWidth, height: cellWidth))
        
        return cell
    }
    
    
}
