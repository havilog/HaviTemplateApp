//
//  DatabaseRepositoryTests.swift
//  DatabaseModuleTests
//
//  Created by 한상진 on 2021/07/01.
//  Copyright © 2021 softbay. All rights reserved.
//

import XCTest

@testable import DatabaseModule
@testable import ThirdPartyManager

import Realm
import RealmSwift

class Ingredient: Object, PropertyRepresentable {
    enum RealmProperty: String {
        case cheese
        case something
    }
    
    @objc public dynamic var cheese: String = ""
    @objc public dynamic var something: String = ""
    
    override static func primaryKey() -> String? { return RealmProperty.something.rawValue }
}

class Pizza: Object, PropertyRepresentable {
    enum RealmProperty: String {
        case name
        case orderNumber
    }
    
    @objc public dynamic var name: String = ""
    @objc public dynamic var orderNumber: Int = 0
    public var ingredients: List<Ingredient> = .init()
    
    override static func primaryKey() -> String? { return RealmProperty.name.rawValue }
    
    convenience init(name: String) {
        self.init()
        
        self.name = name
    }
    
    convenience init(
        name: String,
        orderNumber: Int
    ) {
        self.init()
        
        self.name = name
        self.orderNumber = orderNumber
    }
}

class DatabaseRepositoryTests: XCTestCase {
    var sut: DatabaseRepository!
    var realm: Realm!
    
    override func setUp() {
        // This ensures that each test can't accidentally access or modify the data
        let config: Realm.Configuration = .init(inMemoryIdentifier: self.name)
        realm = try! Realm(configuration: config)
        sut = DatabaseRepository(realm: realm)
    }
    
    override func tearDown() {
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    func test_Fetch_ResultsArray_From_Realm() {
        XCTAssertTrue(realm.isEmpty)
        
        let ing1 = Ingredient()
        ing1.something = "111"
        
        let ing2 = Ingredient()
        ing2.something = "222"
        
        let ings: List<Ingredient> = .init()
        ings.append(ing1)
        ings.append(ing2)
        
        let cheesePizza = Pizza()
        cheesePizza.name = "BBBCheese"
        cheesePizza.ingredients = ings
        
        let potatoPizza = Pizza()
        potatoPizza.name = "PPPPotato"
        potatoPizza.ingredients = ings
        
        try? realm.write {
            realm.add(cheesePizza)
            realm.add(potatoPizza)
        }
        
        let result = sut.fetchObjects(for: Pizza.self)
        
        XCTAssertEqual(result, [cheesePizza, potatoPizza])
        XCTAssertNotEqual(result, [potatoPizza, cheesePizza])
    }
    
    func test_fetch_resultsArray_with_filter() {
        XCTAssertTrue(realm.isEmpty)
        
        let p1 = Pizza(name: "p1")
        let p2 = Pizza(name: "p2")
        let p3 = Pizza(name: "p3")
        
        try? realm.write {
            realm.add(p1)
            realm.add(p2)
            realm.add(p3)
        }
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 3)
        
        let result = sut.fetchObjects(for: Pizza.self, filter: .string(query: "\(Pizza.RealmProperty.name) == 'p1'"))

        XCTAssertEqual(result, [p1])

        XCTAssertEqual(result.first, p1)
    }
    
    func test_fetch_resultsArray_with_sortKey() {
        XCTAssertTrue(realm.isEmpty)
        
        let p3 = Pizza(name: "p3", orderNumber: 2)
        let p2 = Pizza(name: "p2", orderNumber: 1)
        let p1 = Pizza(name: "p1", orderNumber: 0)
        
        try? realm.write {
            realm.add(p3)
            realm.add(p2)
            realm.add(p1)
        }
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 3)
        
        var result = sut.fetchObjects(for: Pizza.self, sortProperty: "orderNumber")
        
        XCTAssertEqual(result, [p1, p2, p3])
        
        result = sut.fetchObjects(for: Pizza.self, sortProperty: "orderNumber", ordering: .descending)
        
        XCTAssertEqual(result, [p3, p2, p1])
    }
    
    func test_Add_TestObject_To_Realm() {
        XCTAssertTrue(realm.isEmpty)
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 0)
        
        let margherita = Pizza()
        margherita.name = "Margherita"
        sut.add(margherita)
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 1)

        if let first = realm.objects(Pizza.self).first {
            XCTAssertEqual(first.name, "Margherita")
        }
    }
    
    func test_Set_Object_To_Realm() {
        XCTAssertTrue(realm.isEmpty)
        
        let p1 = Pizza(name: "p1", orderNumber: 0)
        
        try? realm.write {
            realm.add(p1)
        }
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 1)
        
        let changePizza = Pizza(name: "p1", orderNumber: 1)
        
        sut.set(changePizza)
        
        XCTAssertEqual(realm.objects(Pizza.self).first, changePizza)
    }
    
    func test_Delete_Object_From_Realm() {
        XCTAssertTrue(realm.isEmpty)
        
        let p1 = Pizza(name: "p1", orderNumber: 0)
        
        try? realm.write {
            realm.add(p1)
        }
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 1)
        XCTAssertEqual(realm.objects(Pizza.self).first, p1)
        
        sut.delete(p1)
        
        XCTAssertEqual(realm.objects(Pizza.self).count, 0)
        XCTAssertTrue(realm.isEmpty)
    }
    
    func test_Change_Obejcts_Property() {
        XCTAssertTrue(realm.isEmpty)
        
        let p1 = Pizza(name: "p1", orderNumber: 0)
        
        try? realm.write {
            realm.add(p1)
        }
        
        let pizza = realm.objects(Pizza.self).first!

        pizza.update {
            $0.orderNumber = 9
        }
        
        XCTAssertEqual(realm.objects(Pizza.self).first!.orderNumber, 9)
    }
}
