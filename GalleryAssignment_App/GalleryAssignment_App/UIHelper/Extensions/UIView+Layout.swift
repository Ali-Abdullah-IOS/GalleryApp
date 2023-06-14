//
//  UIView+Layout.swift
//  GalleryAssignment_App
//
//  Created by Mac on 13/06/2023.
//

import Foundation
import UIKit

extension UIView{
    
    public func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    public func centerSuperView(xPadding: CGFloat = 0.0, yPadding: CGFloat = 0.0, size: CGSize = .zero){
       
        translatesAutoresizingMaskIntoConstraints = false
        if let x = superview?.centerXAnchor{
            centerXAnchor.constraint(equalTo: x, constant: xPadding).isActive = true
        }
        
        if let y = superview?.centerYAnchor{
            centerYAnchor.constraint(equalTo: y, constant: yPadding).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    public func fillSuperView(padding: UIEdgeInsets = .zero){
        guard let top = superview?.topAnchor, let leading = superview?.leadingAnchor, let trailing = superview?.trailingAnchor, let bottom = superview?.bottomAnchor else {
            return
        }
        anchor(top: top, leading: leading, bottom: bottom, trailing: trailing, padding: padding)
    }
    
    public func horizontalCenterWith(withView: UIView?){
        translatesAutoresizingMaskIntoConstraints = false
        if let x = withView?.centerXAnchor{
            centerXAnchor.constraint(equalTo: x).isActive = true
        }
    }
    
    public func verticalCenterWith(withView: UIView?){
        translatesAutoresizingMaskIntoConstraints = false
        if let y = withView?.centerYAnchor{
            centerYAnchor.constraint(equalTo: y).isActive = true
        }
    }
    
    public func constraintsWidth(width: CGFloat = 0.0){
        translatesAutoresizingMaskIntoConstraints = false
        constraints.filter({$0.firstAttribute == .width}).first?.isActive = false // Remove First if Width Constraints available
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    public func constraintsWithHeight(height: CGFloat = 0.0){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func constraintsWidhHeight(size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


extension UIViewController{
    
    public func presentTo(viewController: UIViewController, animated: Bool = true){
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}

extension UIView {
//    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addTapGesture(tapNumber: Int = 1, tagId: Int, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        tag = tagId
    }
    ///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    open class BlockTap: UITapGestureRecognizer {
        private var tapAction: ((UITapGestureRecognizer) -> Void)?
        
        public override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
        }
        
        public convenience init (
            tapCount: Int = 1,
            fingerCount: Int = 1,
            action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount
            
            #if os(iOS)
            
            self.numberOfTouchesRequired = fingerCount
            
            #endif
            self.tapAction = action
            self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
        }
        
        @objc open func didTap (_ tap: UITapGestureRecognizer) {
            tapAction? (tap)
        }
    }

}


extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}

extension UIImage {
    // MARK: Write Images to Path
    func writeImageToPath(name:String) {
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let folderURL = documentsUrl.appendingPathComponent("Images")
        let imageurl = folderURL.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: imageurl.path) {
            do{
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error Writing Image: \(error)")
            }
//            print("File Path -- \(imageurl)")
            let data = self.pngData()
            do {
//                print("ImageSend Write image")
                try data!.write(to: imageurl)
            }
            catch {
                print("Error Writing Image: \(error)")
            }
        }
        else {
            print("This file exists -- something is already placed at this location")
        }
        print("ImageSend Completed writeImageToPath")
    }
}
