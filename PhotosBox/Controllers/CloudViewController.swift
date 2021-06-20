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
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private var photosInfo = [PhotoInfo]()
    private var isSelecting = false
    private let progressHud: JGProgressHUD = {
        let hud = JGProgressHUD()
        return hud
    }()
    private var selectedIndexPaths = [IndexPath]() {
        didSet {
            let count = selectedIndexPaths.count
            navigationItem.title = "\(count) photo(s) selected"
            [downloadButton, deleteButton].forEach {
                $0?.alpha = count > 0 ? 1 : 0.5
                $0?.isEnabled = count > 0
            }
            
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
        isSelecting = !isSelecting
        tabBarController?.tabBar.isHidden = isSelecting
        
        if !isSelecting {
            collectionView.indexPathsForSelectedItems?.forEach{
                collectionView.deselectItem(at: $0, animated: false)
            }
        }
        
        downloadButton.isEnabled = isSelecting
        deleteButton.isEnabled = isSelecting
        selectButton.title = isSelecting ? "Done" : "Select"
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let photosIds = selectedIndexPaths.compactMap{ photosInfo[$0.item]._id }
        progressHud.show(in: self.view, animated: false)
        ApiService.shared.deletePhotos(photosIds: photosIds) { (success, deletedPhotos) in
            self.progressHud.dismiss(animated: false)
            success ? self.fetchPhotos() : self.popupMessage(title: "No Internet Connection", message: "You need to connect to the internet to continue.")
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: UIButton) {
        
    }
    
}




extension CloudViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPaths.append(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPaths.removeLast()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photosInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let photoInfo = photosInfo[indexPath.item]
        cell.imageView.image = #imageLiteral(resourceName: "placeholder_image")
        cell.requestImage(urlString: photoInfo.imageUrl)
        return cell
    }
    
    
}


