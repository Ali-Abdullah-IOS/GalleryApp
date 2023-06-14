//
//  AppUtils.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//

import Foundation
import UIKit

class AppUtils{
    static let shared = AppUtils()
    
    func loadImage(fileName: String) -> UIImage? {
        
        let result = fileName.contains("&MAP_")
        var dataCompare = ""
//        print(result)
        if result == true {
            
            let result = fileName.split(separator: ".")
             dataCompare = result[0].count > 38  ? String(fileName.dropFirst(37)) : fileName
            
        }
        else {
            dataCompare = fileName.count > 38  ? String(fileName.dropFirst(37)) : fileName
        }
//        print(dataCompare)
       // let cellImage = AppUtils.shared.loadImage(fileName: dataCompare)
       
       var documentsUrl: URL {
           return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
       }
       let newUrl = documentsUrl.appendingPathComponent("Images")
       let fileURL = newUrl.appendingPathComponent(dataCompare)
        
//        print(fileURL)
       do {
           let imageData = try Data(contentsOf: fileURL)
           let image = UIImage(data: imageData)
           return image
       } catch {
           print("Error loading image : \(error)")
       }
       return nil
   }
}
