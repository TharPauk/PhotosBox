//
//  PhotosController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 05/06/2021.
//

import UIKit
import Photos

class PhotosViewController: GridCollectionView {
    
    private var photos = [UIImage]()
    private var isSelecting = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
}


extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDetailController = storyboard.instantiateViewController(identifier: "PhotoDetailController") as! PhotoDetailController
        print("item = \(indexPath.item)")
        
//        navigationController?.pushViewController(photoDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        cell.imageView.image = photo
        return cell
    }
    
    
}
