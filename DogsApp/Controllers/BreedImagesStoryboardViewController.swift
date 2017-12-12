//
//  BreedImagesViewController.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit
import Kingfisher

final class BreedImagesStoryboardViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dogImageView: UIImageView!
    
    var breed: Breed?
    var service: DogsService = DogsAPI()
    let dogPersistence: DogPersistenceService = DogMemoryCrud.instance
    var dogImages: [String] = []
    var selectedIndex = 0 {
        didSet {
            fetchCurrentImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageGestures()
        setupNavigationItem()
        fetchDogImages()
    }
    
    func setupNavigationItem() {
        navigationItem.title = breed?.name ?? ""
    }
    
    func setupImageGestures() {
        dogImageView.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeOnImage(_:))
        )
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeOnImage(_:))
        )
        swipeLeft.direction = .left
        
        dogImageView.addGestureRecognizer(swipeRight)
        dogImageView.addGestureRecognizer(swipeLeft)
    }
    @objc
    func swipeOnImage(_ gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UISwipeGestureRecognizer else {
            return
        }
        var newValue = selectedIndex
        if gesture.direction == .left {
            newValue = selectedIndex + 1
        } else if gesture.direction == .right {
            newValue = selectedIndex - 1
        }
        
        if newValue < 0 || newValue >= dogImages.count {
            return
        }
        
        selectedIndex = newValue
    }
    
    func fetchDogImages() {
        guard let breed = breed else {
            fatalError("This path should not be possible")
        }
        activityIndicator.startAnimating()
        service.fetchDogImages(forBreed: breed) { result in
            self.activityIndicator.stopAnimating()
            switch result {
            case .success(let images):
                self.dogImages = images
                self.fetchCurrentImage()
            case .error(let error):
                print(error)
            }
        }
        
    }
    
    func fetchCurrentImage() {
        let image = dogImages[selectedIndex]
        guard let imageURL = URL(string:image) else {
            return
        }
        let imageResource = ImageResource(downloadURL: imageURL)
        activityIndicator.startAnimating()
        dogImageView.kf.setImage(with: imageResource, placeholder: nil, options: nil, progressBlock: nil) { image, _, _, _ in
            if let image = image {
                self.dogImageView.image = image
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func favoriteDog() {
        guard let breed = breed else {
            fatalError("This path should be impossible")
        }
        let currentImage = dogImages[selectedIndex]
        let dog = Dog(breed: breed, image: currentImage)
        dogPersistence.save(dog: dog)
    }
   
    
    
}


