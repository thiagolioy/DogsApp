//
//  FavoritesDatasourceSpec.swift
//  DogsAppTests
//
//  Created by sergio.igarashi on 20/03/18.
//  Copyright © 2018 Thiago Lioy. All rights reserved.
//

@testable import DogsApp
import Quick
import Nimble

class FavoritesDatasourceSpec: QuickSpec {
   
    override func spec() {
        
        var tableView: UITableView!
        var dalmatian: Breed!
        var pongo: Dog!
        var perdy: Dog!
        var dogs: [Dog]!
        var sut: FavoritesDatasource!
        
        describe("FavoritesDatasource") {
            
            beforeSuite {
                tableView = UITableView(frame: .zero)
                dalmatian = Breed(name: "Dalmatian")
                pongo = Dog(breed: dalmatian, image: "")
                perdy = Dog(breed: dalmatian, image: "")
                dogs = [pongo,perdy]
                sut = FavoritesDatasource(tableView: tableView,
                                          dogs: dogs)
            }
            
            context("when it's initialized", closure: {
                var sut: FavoritesDatasourceStub!
                
                beforeEach {
                    sut = FavoritesDatasourceStub(tableView: tableView,
                                                  dogs: dogs)
                }
                
                it("should store the given dogs array") {
                    expect(sut).toNot(beNil())
                }
                
                it("should call the register for tableview") {
                    expect(sut.isRegisterCalled).to(beTrue())
                }
                
            })
            
            context("responding to UITableViewDatasource", closure: {
                
                context("when numberOfRows is called", closure: {
                    
                    it("should return the dogs array size", closure: {
                        let rows = sut.tableView(tableView,         numberOfRowsInSection: 0)
                        expect(rows).to(equal(dogs.count))
                    })
                    
                })
            })
            
        }
        
    }
}
