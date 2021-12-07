//
//  PhotosController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit
import CoreData
import JGProgressHUD


class PhotosViewController: GridCollectionView {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var heightAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarView: UIView!
    
    
    // MARK: - Properties
    
    var dataController: DataController!
    private var isSelecting = false
    private var fetchedResultsController: NSFetchedResultsController<Photo>!

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
        
        [uploadButton, deleteButton].forEach {
            $0?.alpha = hasValue ? 1 : 0.5
            $0?.isEnabled = hasValue
        }
    }
    
    var selectedIndexPaths = [IndexPath]() {
        didSet {
            selectionChanged()
        }
    }
    
    private let progressHud: JGProgressHUD = {
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.progress = 0
        return hud
    }()
    
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupFetchedResultsController()
        showPasscodeScreen()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        heightAnchorConstraint.constant = tabBarController?.tabBar.frame.height ?? 83
        navigationItem.title = "Photos"
        setSelectingState(state: false)
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
        setSelectingState()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        selectedIndexPaths = selectedIndexPaths.sorted(by: >)
        selectedIndexPaths.forEach { deletePhoto(at: $0) }
        setSelectingState(state: false)
        deselectAllItems()
    }
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        guard selectedIndexPaths.count > 0 else { return }
        guard AuthService.shared.isLoggedIn else {
            popupMessage(title: "Cannot Upload", message: "You need to login to upload photos.")
            return
        }
        
        let images: [Data] = selectedIndexPaths.compactMap { indexPathToPngData($0) }
        progressHud.show(in: self.view)
        
        ApiService.shared.upload(images: images, progressUpdate: updateProgress(progress:), completion: handleComplete(success:message:))
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
    
    private func updateProgress(progress: Progress) {
        let progressInFloat = Float(progress.fractionCompleted)
        
        progressHud.progress = progressInFloat
        progressHud.detailTextLabel.text = "\(Int(progressInFloat * 100))% complete"
    }
    
    private func handleComplete(success: Bool, message: String?) {
        progressHud.dismiss(animated: true)
        selectButtonPressed(self.selectButton)
        deselectAllItems()
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = tabBarController.viewControllers!.count - 1
        }
    }
    
   
    
    
    // MARK: - Passcode
    
    private func showPasscodeScreen() {
        guard PasscodeService.shared.isPasscodeOn else { return }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let passcodeController = storyBoard.instantiateViewController(identifier: "PasscodeController") as! PasscodeController
        passcodeController.screenType = .unlock
        present(passcodeController, animated: false)
    }
    
    
    
    // MARK: - Cell Selection Functions
    
    private func setSelectingState(state: Bool? = nil) {
        isSelecting = state ?? !isSelecting
        toolBarView.isHidden = !isSelecting
        if !isSelecting {
            deselectAllItems()
        }
        tabBarController?.tabBar.isHidden = isSelecting
        addButton.isEnabled = !isSelecting
        selectButton.title = isSelecting ? "Done" : "Select"
    }
    
    private func deselectAllItems() {
        collectionView.indexPathsForSelectedItems?.forEach{
            collectionView.deselectItem(at: $0, animated: false)
        }
        selectedIndexPaths = []
    }
    
    private func indexPathToPngData(_ indexPath: IndexPath) -> Data {
        let data = fetchedResultsController.fetchedObjects![indexPath.item].data
        return (UIImage(data: data!)?.pngData())!
    }
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SelectPhotos",
              let navController = segue.destination as? UINavigationController,
              let photosSelectionViewController = navController.viewControllers.first as? PhotosSelectionController else {
            return
        }
        photosSelectionViewController.dataController = self.dataController
    }
    
    private func goToPhotoDetail(indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDetailController = storyboard.instantiateViewController(identifier: "PhotoDetailController") as! PhotoDetailController
        if let image = fetchedResultsController.fetchedObjects?[indexPath.item] {
            photoDetailController.image = UIImage(data: image.data!)
        }
        
        navigationController?.pushViewController(photoDetailController, animated: true)
    }
}




// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPaths.removeLast()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelecting ? selectedIndexPaths.append(indexPath): goToPhotoDetail(indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        if let fetchedObjects = fetchedResultsController.fetchedObjects,
           let photoData = fetchedObjects[indexPath.item].data {
            cell.imageView.image = UIImage(data: photoData)
        }
        return cell
    }
    
}



// MARK: - FetchResultsController Functions

extension PhotosViewController: NSFetchedResultsControllerDelegate {
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "photos")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            self.collectionView.reloadData()
        } catch {
            print("Errror in loading photos : \(error.localizedDescription)")
        }
    }
    
    private func deletePhoto(at indexPath: IndexPath) {
        let photoToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(photoToDelete)
        try? dataController.viewContext.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.collectionView.insertItems(at: [newIndexPath])
        case .delete:
            guard let indexPath = indexPath else { return }
            self.collectionView.deleteItems(at: [indexPath])
        default:
            break
        }
    }
}
