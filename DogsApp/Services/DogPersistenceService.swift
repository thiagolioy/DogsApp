//
//  DogPersistenceService.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import Foundation

protocol DogPersistenceService {
    func save(dog: Dog)
    func dogs() -> [Dog]
}

final class DogMemoryCrud: DogPersistenceService {
    
    static let instance = DogMemoryCrud()
    var memoryDogs: [Dog] = []
    
    private init() {}
    
    func save(dog: Dog) {
        memoryDogs.append(dog)
    }
    
    func dogs() -> [Dog] {
        return memoryDogs
    }
    
    
}
