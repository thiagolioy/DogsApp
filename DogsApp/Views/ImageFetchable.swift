//
//  ImageFetchable.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImageFetchable {
    func fetch(imageURL:String, onImage: UIImageView, callback: @escaping () -> Void)
}

final class KFImageFetchable: ImageFetchable {
    func fetch(imageURL:String, onImage: UIImageView, callback: @escaping () -> Void) {
        guard let imageURL = URL(string:imageURL) else {
            callback()
            return
        }
        let imageResource = ImageResource(downloadURL: imageURL)
        onImage.kf.setImage(with: imageResource, placeholder: nil, options: nil, progressBlock: nil) { image, _, _, _ in
            if let image = image {
                onImage.image = image
            }
            callback()
        }
    }
}
