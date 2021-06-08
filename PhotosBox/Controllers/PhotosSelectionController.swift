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
    private var selectedIndexPaths = [IndexPath]() {
        didSet {
            addButton.isEnabled = selectedIndexPaths.count > 0
        }
    }
    var dataController: DataController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
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
        
        addButton.isEnabled = false
        
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
    
    
    private func requestPhoto(at indexPath: IndexPath) {
        
        let asset = assets[indexPath.item]
        let size = CGSize(width: cellWidth, height: cellWidth)
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, _ in
            if let image = image {
                let photo = Photo(context: self.dataController.viewContext)
                photo.data = image.pngData()
                self.dataController.saveContext()
            }
        }
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options,resultHandler: resultHandler)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        selectedIndexPaths.forEach { requestPhoto(at: $0) }
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension PhotosSelectionController: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPaths = self.collectionView.indexPathsForSelectedItems ?? []
        navigationItem.title = "\(selectedIndexPaths.count) photos selected"
    }
    
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