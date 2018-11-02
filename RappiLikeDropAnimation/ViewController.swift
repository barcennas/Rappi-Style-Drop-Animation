//
//  ViewController.swift
//  RappiLikeDropAnimation
//
//  Created by Abraham Barcenas on 10/31/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionItem: UICollectionView!
    
    let items: [(name: String, image: UIImage)] = [("Item 1",#imageLiteral(resourceName: "item2")),("Item 2",#imageLiteral(resourceName: "item4")) ,("Item 3",#imageLiteral(resourceName: "item1")),("Item 4",#imageLiteral(resourceName: "item3"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionItem.delegate = self
        collectionItem.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //collection view is re-laid when rotate or change
        collectionItem.collectionViewLayout.invalidateLayout()
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let cell = gestureRecognizer.view as! ItemCell
            let collection = cell.superview! as! UICollectionView
            
            let imgViewCell = cell.viewWithTag(5) as! UIImageView
            
            let xCell = cell.frame.origin.x
            let yCell = cell.frame.origin.y
            let xCollection = collection.frame.origin.x
            let yCollection = collection.frame.origin.y
            let y = yCell + yCollection
            let x = xCell + xCollection
            
            let imageTag = Int(gestureRecognizer.accessibilityValue!)!
            let imgView = UIImageView(frame: CGRect(x: x, y: y, width: imgViewCell.frame.width, height: imgViewCell.frame.height))
            imgView.image = imgViewCell.image
            imgView.contentMode = .scaleAspectFit
            imgView.isHidden = true
            imgView.tag = imageTag
            self.view.addSubview(imgView)
            
            let shrinkTransform = imgViewCell.transform.scaledBy(x: 0.5, y: 0.5)
            let growTransform = imgViewCell.transform.scaledBy(x: 1, y: 1)
            
            //bounce animation started
            UIView.animate(withDuration: 0.1, animations: {
                imgViewCell.transform = shrinkTransform
            }) { (done) in
                UIView.animate(withDuration: 0.1, animations: {
                    //bounce animation ended
                    imgViewCell.transform = growTransform
                })
            }
            
        }else if gestureRecognizer.state == .changed {
            let location = gestureRecognizer.location(in: self.view)
            let cell = gestureRecognizer.view as! ItemCell
            let collection = cell.superview! as! UICollectionView
            let originY = collection.frame.origin.y + cell.frame.maxY
            
            let imageTag = Int(gestureRecognizer.accessibilityValue!)!
            if let movingView = self.view.viewWithTag(imageTag) {
                
                let xCell = cell.frame.origin.x
                let yCell = cell.frame.origin.y
                let yCollection = collection.frame.origin.y
                let y = yCollection + yCell
                let x = xCell
                
                if location.y > originY + 15 {
                    gestureRecognizer.isEnabled = false
                    gestureRecognizer.isEnabled = true
                    
                    movingView.isHidden = false
                    let originalTransform = movingView.transform
                    let center = (collection.frame.width / 2) - (cell.frame.width / 2)
                    var transformX = x - center
                    transformX *= -1
                    let transformY = self.view.frame.height - y - cell.frame.height
                    
                    let translatedTransform = originalTransform.translatedBy(x: transformX, y: transformY)
                    
                    //translate animation started
                    UIView.animate(withDuration: 0.6, animations: {
                        movingView.transform = translatedTransform
                    }) { (done) in
                        //translate animation ended
                        UIView.animate(withDuration: 0.2, animations: {
                            let x = movingView.frame.origin.x + (movingView.frame.size.width / 2)
                            let y = movingView.frame.origin.y + (movingView.frame.size.height / 2)
                            movingView.frame = CGRect(x: x, y: y, width: 5, height: 5)
                        }, completion: { (done) in
                            movingView.removeFromSuperview()
                            let indexPath = collection.indexPath(for: cell)!
                            let item = self.items[indexPath.row]
                            print("user dragged: ",item.name)
                        })
                    }
                }
            }
        }else if gestureRecognizer.state == .ended {
            //user clicked the item withouth dragging it
            let cell = gestureRecognizer.view as! ItemCell
            let collection = cell.superview! as! UICollectionView
            
             let indexPath = collection.indexPath(for: cell)!
             let item = items[indexPath.row]
            
            print("user clicked: ",item.name)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        let cell = collectionItem.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.configureCell(name: item.name, image: item.image)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.accessibilityValue = "1\(indexPath.row)"
        lpgr.minimumPressDuration = 0.01
        cell.addGestureRecognizer(lpgr)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 90)
    }
    
    
}

