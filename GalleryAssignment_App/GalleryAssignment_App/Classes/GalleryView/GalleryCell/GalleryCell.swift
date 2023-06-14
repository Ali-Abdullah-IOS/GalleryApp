//
//  GalleryCell.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//

import Foundation
import UIKit

class GalleryCell : UICollectionViewCell {
    
    var image: UIImageView?
    
    
    var data: String? = ""{
        didSet{
            if let image_ = AppUtils.shared.loadImage(fileName: data ?? ""){
                image?.image = image_
            }else{
                image?.image = UIImage(named: "Empty")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        contentView.backgroundColor = .red
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 2
    }
    
    func initializedControls(){
        image = UIImageView(image: UIImage(named: "Unknownee"))
        image?.contentMode = .scaleAspectFill
    }
    
    func configureUI(){
        initializedControls()
        
        self.contentView.addSubview(image!)
        image?.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
