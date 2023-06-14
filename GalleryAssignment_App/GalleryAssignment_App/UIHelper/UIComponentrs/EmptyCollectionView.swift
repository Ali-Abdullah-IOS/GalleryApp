//
//  EmptyCollectionView.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//

import Foundation
import UIKit

class EmptyCollectionView: UIView{
    
    var image: UIImage?
    var title: String
    
    
    var lblTitle: UILabel?
    var imageView: UIImageView?
    
    init(title: String, image: UIImage? = nil, frame: CGRect = .zero) {
        self.title = title
        self.image = image
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        setTitle()
        if image != nil{
            setImage()
        }
    }
    
    func setTitle(){
        lblTitle = UILabel()
        lblTitle?.text = title
        lblTitle?.font = UIFont.boldSystemFont(ofSize: 18)
        lblTitle?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5507218317)
        lblTitle?.numberOfLines = 2
        
        addSubview(lblTitle!)
        lblTitle?.centerSuperView()
    }
    
    func setImage(){
        imageView = UIImageView(image: image!)
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor = #colorLiteral(red: 0.5260413289, green: 0.4852359295, blue: 0.8591313958, alpha: 1)
        addSubview(imageView!)
        imageView?.horizontalCenterWith(withView: self)
        imageView?.anchor(top: nil, leading: nil, bottom: lblTitle?.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: .init(width: 170, height: 130))
        
    }
}



