//
//  GalleryView.swift
//  GalleryAssignment_App
//
//  Created by Mac on 14/06/2023.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class GalleryView: UIViewController{
    
    var colGallery: UICollectionView!
    var imagePicker: UIImagePickerController?
    var btnAddChat: UIView?
    var empty: EmptyCollectionView?
    
    private let manager = DatabaseManager()
    var data: [String] = []
    private var gallery: [Gallery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        actions()
        gallery = manager.fetchUsers()
        colGallery.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        empty?.isHidden = ((gallery.count != 0 ? gallery.count : 0) != 0)
    }
    
    //MARK: --- Initialized Controls
    func initializedControls(){
        configureCollectionView()
        
        empty = EmptyCollectionView(title: "Your Gallery is Empty", image: UIImage(named: "Empty"))
        
        btnAddChat = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.5260413289, green: 0.4852359295, blue: 0.8591313958, alpha: 1)
            view.layer.cornerRadius = 30
            let img = UIImageView(image: UIImage(systemName: "plus")!)
            img.contentMode = .scaleAspectFill
            img.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            view.addSubview(img)
            img.constraintsWidhHeight(size: .init(width: 25, height: 25))
            img.centerSuperView()
            return view
        }()
    }
    
    //MARK: --- configure UI
    func configureUI(){
        initializedControls()
        
        view.addSubview(colGallery!)
        view.addSubview(empty!)
        
        view.addSubview(btnAddChat!)
        colGallery.fillSuperView(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        empty?.fillSuperView(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        
        btnAddChat?.anchor(top: nil, leading: nil, bottom: colGallery?.bottomAnchor, trailing: colGallery?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 45, right: 25), size: .init(width: 60, height: 60))
        
        view.bringSubviewToFront(btnAddChat!)
        colGallery?.bringSubviewToFront(btnAddChat!)
        
        empty?.isHidden = true
    }
    
    //--- Configure CollectionView
    func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        colGallery = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        colGallery.alwaysBounceVertical = false
        colGallery.delegate = self
        colGallery.dataSource = self
        colGallery.register(GalleryCell.self, forCellWithReuseIdentifier: "cell")
        colGallery.backgroundColor = .clear
        colGallery.showsVerticalScrollIndicator = false
    }
    
    //Add Images to Gallery OR Camera Options
    func actions(){
        btnAddChat?.addTapGesture(tagId: 0, action: { [self] _ in
            print("Open Camera or Gallery")
            self.handleTap()
        })
    }
}


//MARK: --- PHPicker Controller Delegate (Multipal Gallery Image)
extension GalleryView: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
        let queue = DispatchQueue(label: "Image", attributes: .concurrent)
        queue.async {
            for img in results{
                img.itemProvider.loadObject(ofClass: UIImage.self) { [self] (data, error) in
                    if let image = data as? UIImage{
                        
                        if let data = image.jpegData(compressionQuality: 0) {
                            let filesize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: ByteCountFormatter.CountStyle.memory)
                            print(filesize)
                        }
                        
                        let timestamp = NSDate().timeIntervalSince1970
                        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
                        timestampname = timestampname + ".png"
                        image.writeImageToPath(name: "\(timestampname)")
                        
                        print("PathName:----\(timestampname)")
                        //save image to Local DB
                        manager.addImagesPath(GalleryModel(imageName: timestampname))
                        
                        DispatchQueue.main.async { [self] in
                            gallery = manager.fetchUsers()
                            self.colGallery.reloadData()
                        }
                    }
                }
            }
        }
    }
}

//MARK: --- ImagePicker Controller Delegate (Camera image Capture)
extension GalleryView: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        let queue = DispatchQueue(label: "Image")
        queue.async { [self] in
            if let data = selectedImage.jpegData(compressionQuality: 0) {
                let filesize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: ByteCountFormatter.CountStyle.memory)
               print(filesize)
            }
            
            let timestamp = NSDate().timeIntervalSince1970
            var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            timestampname = timestampname + ".png"
            selectedImage.writeImageToPath(name: "\(timestampname)")
            
            //save image to Local DB
            manager.addImagesPath(GalleryModel(imageName: timestampname))
                        
            DispatchQueue.main.async { [self] in
                gallery = manager.fetchUsers()
                self.colGallery.reloadData()
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}

//MARK: ---- CollectionView Delegate
extension GalleryView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        empty?.isHidden = ((gallery.count != 0 ? gallery.count : 0) != 0)
        return gallery.count != 0 ? gallery.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCell
        cell.data = gallery[indexPath.row].imageName ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = gallery[indexPath.row].imageName ?? ""
        self.presentTo(viewController: previewImageVC(data: data))
    }
}

//MARK: --- CollectionView DelegateFlowLayout
extension GalleryView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width / 4) - 10), height: ((view.frame.width / 4) - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


//MARK: --- Show Options To Open Camera Or Gallery
extension GalleryView{
    
    //------------------------ Choose Options ---------------------------
    func handleTap() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //------------------------ openCamera ---------------------------
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //------------------------ openGalary ---------------------------
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            var config = PHPickerConfiguration()
            config.selectionLimit = 0 // limit of selected image
            config.filter = .images
            let pickerVC = PHPickerViewController(configuration: config)
            pickerVC.delegate = self
            self.present(pickerVC, animated: true)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
