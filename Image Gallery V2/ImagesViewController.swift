//
//  ImagesViewController.swift
//  ImageGallery
//
//  Created by Papa on 25/3/2020.
//  Copyright © 2020 Papa. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    
    // MARK: Document Variables & Methods
    var document: Document?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load the document for Image Gallery
        if document != nil {
            document?.open { success in
                print("Document Open status \(success)")
                if success, let galleryRead = self.document?.gallery {
                    self.gallery = galleryRead
                } else {
                    self.gallery = Gallery(galleryName: "Initial Default - Unable to Open", imageURLs: [URL](), cellsize: 200.0)
                }
            }
        } else {
            self.gallery = Gallery(galleryName: "Initial Default", imageURLs: [URL](), cellsize: 200.0)
        }
        
    }
    
    
    // MARK: Data Model
    var gallery: Gallery? {
        didSet   {
            title = gallery?.galleryName
            imagesCollectionView.reloadData()
        }
    }
        
   

    // MARK: Storyboard
    
    @IBAction func save(_ sender: Any? = nil) {
        document?.gallery = gallery
        if document?.gallery != nil {
            document?.updateChangeCount(.done)
            print("Performed save()")
        }
    }
    
    @IBAction func close(_ sender: Any) {
        save()
        dismiss(animated: true) {
            self.document?.close()
            
        }
        
    }
    @IBOutlet weak var imagesCollectionView: UICollectionView! {
        didSet {
            imagesCollectionView.delegate = self
            imagesCollectionView.dataSource = self
            imagesCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(adjustCellSize)))
            imagesCollectionView.dropDelegate = self
        }
    }
    @objc private func adjustCellSize(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
            
        case .recognized:
            gallery?.cellsize = (gallery!.cellsize) * Double(recognizer.scale)
            recognizer.scale = 1.0
            flowLayout?.invalidateLayout()
        default: break
        }
    }
    
    var flowLayout: UICollectionViewFlowLayout? {           // for use to invalidete layout
        return imagesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell

        cell.imageURL = gallery?.imageURLs[indexPath.item]
        
        return cell
    }
    
    // Setting the cell size via the flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = gallery?.cellsize ?? 200.0
        return CGSize(width: cellSize, height:cellSize)
    }

    
    // Implement the drop support
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy,intent: .insertAtDestinationIndexPath)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            let placeholderContext = coordinator.drop(item.dragItem,
                to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
            item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                DispatchQueue.main.async {
                    if let imageURL = provider as? NSURL {
                        placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                            self.gallery?.imageURLs.insert(imageURL as URL, at: insertionIndexPath.item)
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "showImageDetail" {
                if let imgURL = sender as? URL ,
                    let imageVC = segue.destination.contents as? ImageDetailsViewController {
                    imageVC.imageURL = imgURL
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imagesCollectionView {
            let imageURLSelected = gallery?.imageURLs[indexPath.item]
            performSegue(withIdentifier: "showImageDetail", sender: imageURLSelected)
        }
    }
    

}
