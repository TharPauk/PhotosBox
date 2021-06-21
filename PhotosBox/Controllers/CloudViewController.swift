//
//  CloudViewController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit
import JGProgressHUD

class CloudViewController: GridCollectionView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loginSection: UIView!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var heightAnchorConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    var dataController: DataController!
    private var photosInfo = [PhotoInfo]()
    private var isSelecting = false
    private let progressHud = JGProgressHUD()
    var selectedIndexPaths = [IndexPath]() {
        didSet {
            selectionChanged()
        }
    }
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        heightAnchorConstraint.constant = tabBarController?.tabBar.frame.height ?? 83
        fetchPhotos()
        loginSection.isHidden = AuthService.shared.isLoggedIn
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
       setSelectingState()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let photosIds = selectedIndexPaths.compactMap{ photosInfo[$0.item]._id }
        progressHud.show(in: self.view, animated: false)
    
        ApiService.shared.deletePhotos(photosIds: photosIds, completion: handleDeletePhotos(success:photosInfo:))
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        selectedIndexPaths.forEach { saveToStore(indexPath: $0) }
        
        setSelectingState(state: false)
        deselectAllItems()
        popupMessage(title: "Saved Successfully!", message: "Selected photos are saved Successfully.")
        tabBarController?.selectedIndex = 0
        
    }
    
    // MARK: - Initialization Functions
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.minimumInteritemSpacing = 2.0
    }
    
    
    
    // MARK: - Networking Functions
    
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
    
    private func handleDeletePhotos(success: Bool, photosInfo: [PhotoInfo]) {
        progressHud.dismiss(animated: false)
        success ? self.fetchPhotos() : self.popupMessage(title: "No Internet Connection", message: "You need to connect to the internet to continue.")
        
        setSelectingState(state: false)
        deselectAllItems()
    }
    
    
    
    // MARK: - Cell Selection Functions
    
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
        
        [saveButton, deleteButton].forEach {
            $0?.alpha = hasValue ? 1 : 0.5
            $0?.isEnabled = hasValue
        }
    }
    
    private func deselectAllItems() {
        selectedIndexPaths.forEach{
            collectionView.deselectItem(at: $0, animated: false)
        }
        selectedIndexPaths = []
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
   
    
    
    // MARK: - CoreData Functions
    
    private func saveToStore(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell,
              let image = cell.imageView.image else { return }
        
        let photo = Photo(context: self.dataController.viewContext)
        photo.data = image.pngData()
        dataController.saveContext()
    }
   
}



// MARK: - UICollectionViewDataSource

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


