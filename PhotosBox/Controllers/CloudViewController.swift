//
//  CloudViewController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit
import JGProgressHUD

class CloudViewController: GridCollectionView {
    
    
    @IBOutlet weak var loginSection: UIView!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private var photosInfo = [PhotoInfo]()
    private var isSelecting = false
    private let progressHud = JGProgressHUD()
    
    var selectedIndexPaths = [IndexPath]() {
        didSet {
            selectionChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.minimumInteritemSpacing = 2.0
    }
    
    
    private func selectionChanged() {
        let count = selectedIndexPaths.count
        let hasValue = count > 0
        
        var title = "Photos"
        switch count {
        case 0: title = "Photos"
        case 1: title = "1 photo selected"
        default: title = "\(count) photos selected"
        }
        navigationItem.title = title
        
        [downloadButton, deleteButton].forEach {
            $0?.alpha = hasValue ? 1 : 0.5
            $0?.isEnabled = hasValue
        }
    }
    
    
    
    private func fetchPhotos() {
        guard AuthService.shared.isLoggedIn else { return }
        progressHud.textLabel.text = ""
        progressHud.show(in: self.view, animated: false)
        
        ApiService.shared.getPhotos(completion: handleGetPhotosRequest(success:photosInfo:))
    }
    
    private func handleGetPhotosRequest(success: Bool, photosInfo: [PhotoInfo]) {
        progressHud.dismiss(animated: false)
        
        guard success else {
            popupMessage(title: "No Internet Connection", message: "You need to connect to the internet to continue.")
            return 
        }
        self.photosInfo = photosInfo
        self.collectionView.reloadData()
    }
    
    fileprivate func deselectAllItems() {
        selectedIndexPaths.forEach{
            collectionView.deselectItem(at: $0, animated: false)
        }
        selectedIndexPaths = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPhotos()
        loginSection.isHidden = AuthService.shared.isLoggedIn
    }
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
       setSelectingState()
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let photosIds = selectedIndexPaths.compactMap{ photosInfo[$0.item]._id }
        progressHud.show(in: self.view, animated: false)
        ApiService.shared.deletePhotos(photosIds: photosIds) { (success, deletedPhotos) in
            self.progressHud.dismiss(animated: false)
            success ? self.fetchPhotos() : self.popupMessage(title: "No Internet Connection", message: "You need to connect to the internet to continue.")
            
            self.setSelectingState(state: false)
            self.deselectAllItems()
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: UIButton) {
        
    }
    
    
    private func setSelectingState(state: Bool? = nil) {
        isSelecting = state ?? !isSelecting
        
        if !isSelecting {
            deselectAllItems()
        }
        tabBarController?.tabBar.isHidden = isSelecting
        settingsButton.isEnabled = !isSelecting
        selectButton.title = isSelecting ? "Done" : "Select"
    }
    
}




extension CloudViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelecting ? selectedIndexPaths.append(indexPath): goToPhotoDetail(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPaths.removeLast()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photosInfo.count
    }
    
    private func goToPhotoDetail(indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDetailController = storyboard.instantiateViewController(identifier: "PhotoDetailController") as! PhotoDetailController
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        photoDetailController.image = cell.imageView.image
        
        navigationController?.pushViewController(photoDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let photoInfo = photosInfo[indexPath.item]
        cell.imageView.image = #imageLiteral(resourceName: "placeholder_image")
        cell.requestImage(urlString: photoInfo.imageUrl)
        return cell
    }
    
    
}


