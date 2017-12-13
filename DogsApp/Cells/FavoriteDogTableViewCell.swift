//
//  FavoriteDogTableViewCell.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit
import Kingfisher
import Reusable

class FavoriteDogTableViewCell: UITableViewCell {
 
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    let imageFetchable: ImageFetchable = KFImageFetchable()
    
    
    func setup(dog: Dog) {
        breed.text = dog.breed.name
        imageFetchable.fetch(imageURL: dog.image, onImage: dogImage) {}
    }
    
}

extension FavoriteDogTableViewCell: NibReusable {}
