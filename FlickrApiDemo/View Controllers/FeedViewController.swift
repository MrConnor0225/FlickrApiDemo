//
//  FeedViewController.swift
//  ImagesWall
//
//  Created by Connor on 2020/11/19.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var colloectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var items = [MediaData]()
    
    let urlStr = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let columnCount: CGFloat = 3
        let space: CGFloat = 2
        //flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        let itemWidth = (view.bounds.width - space * (columnCount - 1)) / columnCount
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        colloectionView.delegate = self
        colloectionView.dataSource = self
        fetchImage(urlStr: urlStr)
        //refreshCollectionView()
    }
    
    
//    func refreshCollectionView() {
//        print("####")
//        let refreshController = UIRefreshControl()
//        refreshController.attributedTitle = NSAttributedString(string: "下滑更新")
//        refreshController.addTarget(self, action: #selector(fetchImage(urlStr:)), for: .valueChanged)
//        self.colloectionView.refreshControl = refreshController
//    }


    @objc func fetchImage(urlStr: String) {
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                   let items = try? JSONDecoder().decode(Items.self, from: data) {
                    self.items = items.items
                    DispatchQueue.main.async {
                        self.colloectionView.reloadData()
                    }
                } else {
                    print("fetchImage fail")
                }
            }.resume()
        } else {
            print("url fail")
        }
    }

}


extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FeedCollectionViewCell.self)", for: indexPath) as! FeedCollectionViewCell
        
        let url = items[indexPath.item].media.m
        cell.imageUrl = URL(string: url)
        NetworkUtil.downloadImage(url: URL(string: url)!, handler: { (image) in
            if cell.imageUrl == URL(string: url) , let image = image  {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
            
            
        })
        
        return cell
    }
    
    
}
