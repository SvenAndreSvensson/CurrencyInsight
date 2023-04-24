//
//  Storage.swift
//  Networking
//
//  Created by Sven Svensson on 20/03/2023.
//

import SwiftUI
import Foundation

protocol Storage {
    func save<T: Encodable>(_ object: T, forKey key: String) throws
    func load<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T?
    func delete(forKey key: String)
}

struct StorageKey: EnvironmentKey {
    static let defaultValue: Storage = UserDefaultsStorage()
}

extension EnvironmentValues {
    var storage: Storage {
        get { self[StorageKey.self] }
        set { self[StorageKey.self] = newValue }
    }
}
