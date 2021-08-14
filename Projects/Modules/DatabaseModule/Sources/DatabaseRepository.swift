//
//  DatabaseRepository.swift
//  DatabaseModule
//
//  Created by 한상진 on 2021/07/01.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation
import ThirdPartyManager

import RealmSwift

// MARK: Protocol

/// Object타입의 property를 접근할 때에는 write transaction안에서 접근해야한다.
/// ex) Pizza: Object
/// let pizza: Pizza = Pizza(name: "cheese")
/// realm.add(pizza)
/// let test = realm.objects(Pizza.self).first
/// test.update {
///     $0.name = "potato"
/// }
/// 이런식으로 update함수를 써서 프로퍼티를 변경해야한다.
public protocol ObjectPropertyUpdatable { }
extension ObjectPropertyUpdatable where Self: Object {
    public func update(_ block: (Self) throws -> Void) rethrows {
        try? self.realm?.safeWrite {
            try? block(self)
        }
    }
}
extension Object: ObjectPropertyUpdatable { }

/// Object class 안에 Enum으로 RealmProperty를 정의하여
/// "name" 과 같은 string literal을
/// ClassName.RealmProperty.rawvalue로 쓸 수 있게 하기 위해 정의
public protocol PropertyRepresentable {
    associatedtype RealmProperty
}

public protocol DatabaseRepositoryType: AnyObject {
//    외부에서 실제 realm에 직접 접근하는 경우가 필요할 경우 필요
//    var realm: Realm { get }
    
    func fetchObjects<T: Object>(
        for type: T.Type,
        filter: QueryFilter?,
        sortProperty: String?,
        ordering: OrderingType
    ) -> [T]
    func fetchObjectsResults<T: Object>(
        for type: T.Type,
        filter: QueryFilter?,
        sortProperty: String?,
        ordering: OrderingType
    ) -> Results<T>
    
    func add(_ object: Object?)
    func set(_ object: Object?)
    func set(_ objects: [Object]?)
    func delete(_ object: Object?)
    func delete(_ objects: [Object]?)
}

extension DatabaseRepositoryType {
    // default value를 주기 위해 사용
    public func fetchObjects<T: Object>(
        for type: T.Type,
        filter: QueryFilter? = nil,
        sortProperty: String? = nil,
        ordering: OrderingType = .ascending
    ) -> [T] {
        return fetchObjects(for: type, filter: filter, sortProperty: sortProperty, ordering: ordering)
    }
    
    public func fetchObjectsResults<T: Object>(
        for type: T.Type,
        filter: QueryFilter? = nil,
        sortProperty: String? = nil,
        ordering: OrderingType = .ascending
    ) -> Results<T> {
        return fetchObjectsResults(for: type, filter: filter, sortProperty: sortProperty, ordering: ordering)
    }
}

// MARK: Constant

public enum QueryFilter {
    case string(query: String)
    case predicate(query: NSPredicate)
}

public enum OrderingType {
    case ascending
    case descending
}

public final class DatabaseRepository: DatabaseRepositoryType {

    private let realm: Realm
    
    // MARK: Init
    
    public init(config: Realm.Configuration) {
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            DatabaseLogger.fatal("Realm config failed")
            fatalError()
        }
    }
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    // MARK: Query
    
    /// Results<T>가 아닌 [T]를 반환하는 이유는
    /// Results는 Realm에 종속적인 타입이기 때문에
    /// 상위 모듈에서 Realm을 import해주지 않기 위해서
    /// 필요한 query나 sortedKey를 인자로 받아서
    /// DatabaseRepository에서 필요한 쿼리를 수행 후 반환.
    /// - Parameters:
    ///   - type: 가져올 타입
    ///   - filter: String or NSPredicate
    ///   - sortProperty: 소팅이 필요할 경우 키값
    ///   - ordering: 오름차 순 / 내림차 순
    public func fetchObjects<T: Object>(
        for type: T.Type,
        filter: QueryFilter? = nil,
        sortProperty: String? = nil,
        ordering: OrderingType = .ascending
    ) -> [T] {
        fetchObjectsResults(for: T.self, filter: filter, sortProperty: sortProperty, ordering: ordering).toArray()
    }
    
    public func fetchObjectsResults<T: Object>(
        for type: T.Type,
        filter: QueryFilter? = nil,
        sortProperty: String? = nil,
        ordering: OrderingType = .ascending
    ) -> Results<T> {
        var results = realm.objects(T.self)
        
        if let filter = filter {
            switch filter {
            case let .predicate(query):
                results = results.filter(query)
            case let .string(query):
                results = results.filter(query)
            }
        }
        
        if let sortProperty = sortProperty {
            results = results.sorted(byKeyPath: sortProperty, ascending: ordering == .ascending)
        }
        
        DatabaseLogger.fetch(results)
        
        return results
    }
    
    // MARK: CRUD
    
    public func add(_ object: Object?) {
        guard let object = object else { return }
        
        try? realm.safeWrite {
            realm.add(object)
        }
        
        DatabaseLogger.write(object)
    }
    
    public func set(_ object: Object?) {
        guard let object = object else { return }
        
        try? realm.safeWrite {
            realm.add(object, update: .all)
        }
        
        DatabaseLogger.write(object)
    }
    
    public func set(_ objects: [Object]?) {
        guard let objects = objects else { return }
        
        try? realm.safeWrite {
            realm.add(objects, update: .all)
        }
        
        DatabaseLogger.write(objects)
    }
    
    public func delete(_ object: Object?) {
        guard let object = object else { return }
        
        try? realm.safeWrite {
            realm.delete(object)
        }
        
        DatabaseLogger.delete(object)
    }
    
    public func delete(_ objects: [Object]?) {
        guard let objects = objects else { return }
        
        try? realm.safeWrite {
            realm.delete(objects)
        }
        
        DatabaseLogger.delete(objects)
    }
    
    public func deleteAll() {
        try? realm.safeWrite {
            realm.deleteAll()
        }
        
        DatabaseLogger.delete("all database deleted")
    }
}
