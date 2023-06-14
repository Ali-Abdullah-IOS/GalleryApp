//
//  Gallery+CoreDataProperties.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//
//

import Foundation
import CoreData


extension Gallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gallery> {
        return NSFetchRequest<Gallery>(entityName: "Gallery")
    }

    @NSManaged public var imageName: String?

}

extension Gallery : Identifiable {

}
