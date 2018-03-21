//
//  FavoritesDatasourceSpec.swift
//  DogsAppTests
//
//  Created by sergio.igarashi on 19/03/18.
//  Copyright © 2018 Thiago Lioy. All rights reserved.
//

@testable import DogsApp
import XCTest

class FavoritesDatasourceTest: XCTestCase {
    
    var tableView: UITableView!
    var dalmatian: Breed!
    var pongo: Dog!
    var perdy: Dog!
    var dogs: [Dog]!
    var sut: FavoritesDatasource!
    
    override func setUp() {
        //Arrange
         tableView = UITableView(frame: .zero)
         dalmatian = Breed(name: "Dalmatian")
         pongo = Dog(breed: dalmatian, image: "")
         perdy = Dog(breed: dalmatian, image: "")
         dogs = [pongo,perdy]
         sut = FavoritesDatasource(tableView: tableView,
                                      dogs: dogs)
    }
    
    func testInitShouldStoreTheDogsArray(){
        XCTAssertNotNil(sut.dogs)
    }
    
    func testInitShouldCallRegisterToTableView(){
        let sut = FavoritesDatasourceStub(tableView: tableView, dogs: dogs)
        XCTAssertTrue(sut.isRegisterCalled)
    }
    
    func testNumberOfRowsInSectionShouldReturnTheDogsArraySize(){
        //Act
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)
        //Assert
        XCTAssertTrue(rows == dogs.count)
    }
    
    func testCellForRowShouldReturnAValidCell(){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView,
                                 cellForRowAt: indexPath) as? FavoriteDogTableViewCell
        XCTAssertNotNil(cell)
    }
    
}

