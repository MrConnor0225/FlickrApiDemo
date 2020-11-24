//
//  NetworkUtil.swift
//  ImagesWall
//
//  Created by Connor on 2020/11/18.
//

import Foundation
import UIKit

struct NetworkUtil {
    static func downloadImage(url: URL, handler: @escaping (UIImage?) ->()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                handler(image)
            } else {
                handler(nil)
            }
        }
        task.resume()
    }
}
