//
//  DatabaseManager.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//

import Foundation
import UIKit
import CoreData


class DatabaseManager {

//    private var context: NSManagedObjectContext {
//        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func addImagesPath(_ user: GalleryModel) {
        let galleryEntity = Gallery(context: context) // User create karta the
        addUpdateImagePath(galleryEntity: galleryEntity, photo: user)
    }

    private func addUpdateImagePath(galleryEntity: Gallery, photo: GalleryModel) {
        galleryEntity.imageName = photo.imageName
        saveContext()
    }

    func fetchUsers() -> [Gallery] {
        var Photos: [Gallery] = []

        do {
            Photos = try context.fetch(Gallery.fetchRequest())
        }catch {
            print("Fetch user error", error)
        }

        return Photos
    }

    func saveContext() {
        do {
            try context.save() // MIMP
        }catch {
            print("User saving error:", error)
        }
    }
}
