//
//  BigPhotoViewController.swift
//  ImagesWall
//
//  Created by Connor on 2020/11/20.
//

import UIKit

class BigPhotoViewController: UIViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let space:CGFloat = 2
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        let itemWidth = self.view.frame.width - space
        let itemHeight = self.view.frame.height - space
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        DispatchQueue.main.async { [self] in
            collectionView.reloadData()
        }
    }

}

extension BigPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("小圖::\(photos[indexPath.item].imageUrl)")
        print("大圖::\(photos[indexPath.item].bigImageUrl)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BigPhotoCollectionViewCell.self)", for: indexPath) as! BigPhotoCollectionViewCell
        NetworkUtil.downloadImage(url: photos[indexPath.item].bigImageUrl, handler: { (image) in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        })
        
        return cell
    }
 

}



