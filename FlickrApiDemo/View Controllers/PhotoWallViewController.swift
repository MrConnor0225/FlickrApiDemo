//
//  ViewController.swift
//  ImagesWall
//
//  Created by Connor on 2020/11/17.
//

import UIKit

class PhotoWallViewController: UIViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var colloectionView: UICollectionView!
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colloectionView.delegate = self
        colloectionView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let columnCount:CGFloat = 3
        let space:CGFloat = 2
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        let itmeSize = (view.bounds.width - columnCount * space ) / columnCount
        flowLayout.itemSize = CGSize(width: itmeSize, height: itmeSize)
    }
    
   
    func fetchData(urlStr: String) {
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                   let searchData = try? JSONDecoder().decode(SearchData.self, from: data) {
                    self.photos = searchData.photos.photo
                    DispatchQueue.main.async {
                        self.colloectionView.reloadData()
                    }
                } else {
                    print("photoData fail")
                }
            }.resume()
        }
    }
    
    @IBAction func tapTouch(_ sender: Any) {
        view.endEditing(true)
    }
    
    
}

extension PhotoWallViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotoCollectionViewCell.self)", for: indexPath) as! PhotoCollectionViewCell
        let imageUrl = photos[indexPath.item].imageUrl
        cell.imageUril = imageUrl
        NetworkUtil.downloadImage(url: imageUrl, handler: { (image) in
            if cell.imageUril == imageUrl, let image = image {
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            }
        })
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigPhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "\(BigPhotoViewController.self)") as! BigPhotoViewController
        bigPhotoViewController.photos = photos
        self.navigationController?.pushViewController(bigPhotoViewController, animated: true)
    }
    
}

extension PhotoWallViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.returnKeyType = .search
        let searchText = searchBar.searchTextField.text ?? ""
        let urlStr =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5366ee8d4e8db9a00b472374ec424c1d&text=\(searchText)&format=json&nojsoncallback=1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        fetchData(urlStr: urlStr)
        searchBar.resignFirstResponder()
    }

    
    

}

