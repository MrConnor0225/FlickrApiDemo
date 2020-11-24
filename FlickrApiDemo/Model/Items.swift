//
//  Media.swift
//  ImagesWall
//
//  Created by Connor on 2020/11/19.
//

import Foundation

struct Media: Decodable {
    var m: String
}

struct MediaData: Decodable{
    var media: Media
    var link: String
}

struct Items: Decodable {
    var items: [MediaData]
}
