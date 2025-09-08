//
//  UserDefaultsHelper.swift
//  Class
//
//  Created by Song Kim on 9/3/25.
//

import UIKit

final class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    var token: String? {
        get {
            return defaults.string(forKey: "token")
        }
        set {
            return defaults.set(newValue, forKey: "token")
        }
    }
    
    func checkLogin() -> Bool {
        return token != nil
    }
    
    var userId: String? {
        get {
            return defaults.string(forKey: "userId")
        }
        set {
            return defaults.set(newValue, forKey: "userId")
        }
    }
    
    func clearToken() {
        defaults.removeObject(forKey: "token")
    }
}
