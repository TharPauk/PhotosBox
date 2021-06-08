//
//  DataController.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 08/06/2021.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        viewContext = persistentContainer.viewContext
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError("Error in loading persistent stores : \(error?.localizedDescription)")
            }
            
            completion?()
        }
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        try? viewContext.save()
    }
}
