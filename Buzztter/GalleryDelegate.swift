//
//  GalleryDelegate.swift
//  Buzztter
//
//  Created by kou yamamoto on 2021/01/08.
//

import ImageViewer
import Foundation

class GalleryDelegate: GalleryItemsDataSource {
    
    private let items: [GalleryItem]
    
    init(imageUrls: [String]) {
        
        items = imageUrls.compactMap { $0 }.map { imageUrl in
            GalleryItem.image { imageCompletion in
              imageCompletion(UIImage(url: imageUrl))
            }
        }
    }

    func itemCount() -> Int {
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
    }
}
