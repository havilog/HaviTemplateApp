//
//  BaseRealmTests.swift
//  DatabaseModuleTests
//
//  Created by 한상진 on 2021/07/06.
//  Copyright © 2021 softbay. All rights reserved.
//

import XCTest

@testable import DatabaseModule
@testable import ThirdPartyManager

import Realm
import RealmSwift

class RealmWrapperTests: XCTestCase {
    
    var sut: BaseRealm!
    var realm: Realm!

    override func setUpWithError() throws {
        realm = try! Realm(
            configuration: .init(
                inMemoryIdentifier: self.name,
                schemaVersion: 10000,
                migrationBlock: { migration, oldSchemaVersion in
                    migration.enumerateObjects(ofType: Pizza.className()) { oldObject, newObject in
                        if oldSchemaVersion < 10000 {
                            let name = oldObject!["name"] as! String
                            let orderNumber = oldObject!["orderNumber"] as! Int
                            newObject!["nameOrder"] = "\(name)\(orderNumber)"
                        }
                    }
                }
            )
        )
        
        sut = BaseRealm(testRealm: realm)
    }

    override func tearDownWithError() throws {
        try? realm.write {
            realm.deleteAll()
        }
        
        realm = nil
        sut = nil
    }
    
    func test_BaseRealm_WrappedObject_fetchObjects() {
        let p1 = Pizza(name: "test1", orderNumber: 1)
        let p2 = Pizza(name: "test2", orderNumber: 2)
        let p3 = Pizza(name: "test3", orderNumber: 3)
        
        try? realm.write {
            realm.add(p1)
            realm.add(p3)
            realm.add(p2)
        }
        
        XCTAssertEqual(sut.wrappedValue.fetchObjects(for: Pizza.self), [p1, p3, p2])
        
        try? realm.write {
            realm.delete(p2)
        }
        
        XCTAssertEqual(sut.wrappedValue.fetchObjects(for: Pizza.self), [p1, p3])
    }
    
    func test_BaseRealm_WrappedObject_add_set_delete() {
        let p1 = Pizza(name: "test1", orderNumber: 1)
        let p2 = Pizza(name: "test2", orderNumber: 2)
        let p3 = Pizza(name: "test3", orderNumber: 3)
        
        sut.wrappedValue.add(p1)
        
        XCTAssertEqual(realm.objects(Pizza.self).first, p1)
        
        sut.wrappedValue.set([p3, p2])
        
        XCTAssertEqual(realm.objects(Pizza.self).toArray(), [p1, p3, p2])
        
        sut.wrappedValue.delete(p3)
        
        XCTAssertEqual(realm.objects(Pizza.self).toArray(), [p1, p2])
    }
}
