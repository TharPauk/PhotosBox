//
//  Photo+Extensions.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 08/06/2021.
//

import CoreData
import Foundation

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}
