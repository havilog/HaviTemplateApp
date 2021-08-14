//
//  RealmWrapper.swift
//  DatabaseModule
//
//  Created by 한상진 on 2021/07/02.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation
import ThirdPartyManager

import RealmSwift

// MARK: Sample

class SampleClass: Object, PropertyRepresentable {
    enum RealmProperty: String {
        case firstName
        case lastName
        case fullName
        case someAddedProperty
    }
    
    /// String, Date 는 String? = nil로 옵셔널 선언이 가능하지만,
    /// Int, Double 같은 아이들은
    /// let age = RealmOptional<Int>()
    /// 와 같이 생성해야 한다.
    
    @objc dynamic var firstName: String = "" // version 0
    @objc dynamic var lastName: String = "" // version 0
    @objc dynamic var fullName: String = "" // added at version 1
    @objc dynamic var someAddedProperty: String = "" // added at version 2
    
    override static func primaryKey() -> String? { return RealmProperty.fullName.rawValue }
}

// MARK: BaseRealm

private let schemaVersion: UInt64 = 0

/// BaseRealm은 RealmObjectList의 property로 한 번만 초기화 된다.
/// migration block에서 마이그레이션은 보통 AppDelegate에서 실행되어야 한다.
@propertyWrapper
public struct BaseRealm {
    private let testRealm: Realm?
    
    public var wrappedValue: DatabaseRepositoryType {
        return DatabaseRepository(realm: testRealm == nil ? realm : testRealm!)
    }
    
    private var realm: Realm {
        // swiftlint:disable force_try
        return try! Realm(configuration: realmConfiguration)
        // swiftlint:enable force_try
    }
    
    private var realmConfiguration: Realm.Configuration {
        // Test를 위한 migration block이 있으면 Test를 넣어줌
        return .init(
            schemaVersion: schemaVersion,
            migrationBlock: migrationBlock
        )
    }
    
    private var migrationBlock: MigrationBlock {
        /// migration block 사용법 sample
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            migration.enumerateObjects(ofType: SampleClass.className()) { oldObject, newObject in
                // swiftlint:disable force_cast
                if oldSchemaVersion < 1 {
                    let firstName = oldObject!["firstName"] as! String
                    let lastName = oldObject!["lastName"] as! String
                    newObject!["fullName"] = "\(firstName)\(lastName)"
                }
                // swiftlint:enable force_cast
                
                if oldSchemaVersion < 2 {
                    newObject!["someAddedProperty"] = ""
                }
            }
        }
        
        return migrationBlock
    }
    
    public init(
        testRealm: Realm? = nil
    ) {
        self.testRealm = testRealm
    }
}
