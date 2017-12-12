//
//  BreedImagesViewCodeViewController.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit
final class BreedImagesViewCodeViewController: UIViewController {
    let controllerView = BreedImagesControllerView()
    let breed: Breed
    let service: DogsService
    let dogPersistence: DogPersistenceService
    var dogImages: [String] = []
    
    init(breed: Breed, service: DogsService = DogsAPI(),
         dogPersistence: DogPersistenceService = DogMemoryCrud.instance) {
        self.breed = breed
        self.service = service
        self.dogPersistence = dogPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = controllerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupDelegate()
        fetchDogImages()
    }
    
    func setupDelegate() {
        controllerView.delegate = self
    }
    
    func setupNavigationItem() {
        navigationItem.title = breed.name
    }
    
    func fetchDogImages() {
        controllerView.state = .loading
        service.fetchDogImages(forBreed: breed) { result in
            switch result {
            case .success(let images):
                self.controllerView.state = .ready(images)
            case .error(let error):
                print(error)
                self.controllerView.state = .error
            }
        }
        
    }
}

extension BreedImagesViewCodeViewController: BreedImagesControllerViewDelegate {
    func didFavorite(image: String) {
        let dog = Dog(breed: breed, image: image)
        dogPersistence.save(dog: dog)
    }
}
