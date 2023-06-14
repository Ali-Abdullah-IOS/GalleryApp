//
//  PreviewImageView.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//

import Foundation
import UIKit

class previewImageVC: UIViewController {
    
    var imgVedioView = UIImageView(image: UIImage(named: "Unknownee"))
    var imageData = ""
    init(data : String? = "" ){
        self.imageData = data ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        loadImage()
    }
    
    func initilization(){
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.navigationController?.navigationBar.isHidden = true
        
        let swipeUpDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeUpDown.direction = .down
    }
    
    func configureUI(){
        initilization()
        
        view.addSubview(imgVedioView )
        imgVedioView.contentMode = .scaleAspectFit
        imgVedioView.enableZoom()
        imgVedioView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    func loadImage(){
        if let image_ = AppUtils.shared.loadImage(fileName: imageData){
            imgVedioView.image = image_
        }else{
            imgVedioView.image = UIImage(systemName: "photo.fill")
        }
    }
    
    @objc func back(){
        self.dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
