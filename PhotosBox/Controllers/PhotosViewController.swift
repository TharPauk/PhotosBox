//
//  PhotosController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit
import CoreData


class PhotosViewController: GridCollectionView {
    
    private var photos = [UIImage]()
    private var isSelecting = false
    private var fetchedResultsController: NSFetchedResultsController<Photo>!
    var dataController: DataController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
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
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
        isSelecting = !isSelecting
        collectionView.allowsSelection = isSelecting
        collectionView.allowsMultipleSelection = isSelecting
        sender.title = isSelecting ? "Done" : "Select"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.minimumInteritemSpacing = 2.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SelectPhotos",
              let navController = segue.destination as? UINavigationController,
              let photosSelectionViewController = navController.viewControllers.first as? PhotosSelectionController else {
            print("return")
            return
        }
        photosSelectionViewController.dataController = self.dataController
    }
    
}


extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let photoDetailController = storyboard.instantiateViewController(identifier: "PhotoDetailController") as! PhotoDetailController
//        print("item = \(indexPath.item)")
        
//        navigationController?.pushViewController(photoDetailController, animated: true)
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



extension PhotosViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.collectionView.insertItems(at: [newIndexPath])
        default:
            break
        }
    }
}
