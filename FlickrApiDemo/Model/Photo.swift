//
//  Photo.swift
//  ImagesWall
//
//  Created by Connor on 2020/11/17.
//

import Foundation



struct Photo: Decodable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    var imageUrl: URL{
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    var bigImageUrl: URL{
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")!
    }
}

struct PhotoData: Decodable {
    var photo: [Photo]
}

struct SearchData: Decodable {
    var photos: PhotoData
}
