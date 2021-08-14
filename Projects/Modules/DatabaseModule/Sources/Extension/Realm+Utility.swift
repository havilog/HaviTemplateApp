//
//  Realm+Utility.swift
//  DatabaseModule
//
//  Created by 한상진 on 2021/07/02.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation
import ThirdPartyManager

import RealmSwift

/// detached extension은 mobile fax에 있는 extension 로직을 가져온 것으로,
/// 현재 맨 아래 있는 toArray를 제외한 extension은 사용하지 않는다.
protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    
    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            
            if property.isArray == true {
                // Realm List property support
                let detachable = value as? DetachableObject
                detached.setValue(detachable?.detached(), forKey: property.name)
            } else if property.type == .object {
                // Realm Object property support
                let detachable = value as? DetachableObject
                detached.setValue(detachable?.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

extension List: DetachableObject {
    func detached() -> List<Element> {
        let result = List<Element>()
        
        forEach {
            if let detachable = $0 as? DetachableObject {
                if let detached = detachable.detached() as? Element {
                    result.append(detached)
                }
            } else {
                result.append($0) // Primtives are pass by value; don't need to recreate
            }
        }
        
        return result
    }
    
    func toArray() -> [Element] {
        return Array(self.detached())
    }
}

extension Results {
    public func toArray() -> [Element] {
        return Array(self)
    }
    
    public func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
