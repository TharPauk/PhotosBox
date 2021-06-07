//
//  PhotosSelectionController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 07/06/2021.
//

import UIKit
import Photos

class PhotosSelectionController: GridCollectionView {
    
    private var assets = PHFetchResult<PHAsset>()
    private var isSelecting = false
  
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        requestPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
  
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.minimumInteritemSpacing = 2.0
    }
    
    private func requestPermission() {
        guard PHPhotoLibrary.authorizationStatus() != .authorized
        else {
            loadPhotos()
            return
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.collectionView.reloadData()
            }
        }
        self.goToSettingsAlert()
    }
    
    private func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        assets = PHAsset.fetchAssets(with: options)
        collectionView.reloadData()
    }
    
    private func goToSettingsAlert() {
        let alertVC = UIAlertController(title: "Please Allow Access to Your Photos", message: "This allows Photos Box to store photos locally or upload to cloud storage.", preferredStyle: .alert)
        let goToSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        [goToSettingsAction, cancelAction].forEach { alertVC.addAction($0) }
        alertVC.preferredAction = goToSettingsAction
        present(alertVC, animated: true)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let selectedIndexPaths = collectionView.indexPathsForSelectedItems
//        DataModel.selectedAssets = selectedIndexPaths?.compactMap{ assets[$0.item] } ?? []
        self.dismiss(animated: true)
    }
    
}


extension PhotosSelectionController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let asset = assets[indexPath.item]
        cell.loadImage(asset: asset, targetSize: CGSize(width: cellWidth, height: cellWidth))
        return cell
    }
    
    
}
