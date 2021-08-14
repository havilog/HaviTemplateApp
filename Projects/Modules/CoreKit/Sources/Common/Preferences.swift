//
//  Preferences.swift
//  CoreKit
//
//  Created by 한상진 on 2021/07/21.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

public struct Preferences {
    /// sample
    @ValueProperty(uniqueKey: "isLoggedIn", defaultValue: false)
    static var isLoggedIn: Bool
}

// MARK: Protocol

/// ValueProperty의 경우 optional일 경우 set newvalue에서 앱이 죽을 수 있으므로
/// optional로 캐스팅 한 뒤에 nil일 경우 removeObject를 해줘야한다.
protocol OptionalType {
    func isNil() -> Bool
}

extension Optional: OptionalType {
    func isNil() -> Bool { return self == nil }
}

/// 공통으로 쓰이는 타입 정의
class UserDefaultStorage<T> {
    let uniqueKey: String
    let defaultValue: T
    
    init(uniqueKey: String, defaultValue: T) {
        self.uniqueKey = uniqueKey
        self.defaultValue = defaultValue
    }
}

/// Codable한 모델을 UserDefault에 저장하기 위한 객체
@propertyWrapper
final class CodableProperty<T: Codable>: UserDefaultStorage<T> {
    var projectedValue: CodableProperty<T> { return self }
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: uniqueKey) as? Data,
                  let decodedData = try? PropertyListDecoder().decode(T.self, from: data)
            else { return defaultValue }
            
            return decodedData
        }
        
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: uniqueKey)
        }
    }
}

/// String, Int등의 기본적인 value들을 저장하기 위한 객체
@propertyWrapper
final class ValueProperty<T>: UserDefaultStorage<T> {
    var projectedValue: ValueProperty<T> { return self }
    var wrappedValue: T {
        get {
            UserDefaults.standard.value(forKey: uniqueKey) as? T ?? defaultValue
        }
        
        set {
            if let value = newValue as? OptionalType, value.isNil() {
                UserDefaults.standard.removeObject(forKey: uniqueKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: uniqueKey)
            }
        }
    }
}
