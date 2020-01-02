//
//  UserSession.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
class UserSession {
    static let current = UserSession()
    private static let userSessionKey = "USER_SESSION_KEY"
    private let defaults = UserDefaults.standard
    var token: MagnetonAPIObject.UserToken?
    var isLoggedIn: Bool {
        if token == nil {
            _ = retrieveSession()
        }
        return token != nil
    }

    func invalidate() {
        defaults.set(nil, forKey: UserSession.userSessionKey)
        token = nil
    }

    func retrieveSession() -> Bool {
        if let savedToken = defaults.string(forKey: UserSession.userSessionKey) {
            token = MagnetonAPIObject.UserToken(token: savedToken)
            return true
        }
        return false
    }

    func initalizeSession(token: MagnetonAPIObject.UserToken?) {
        self.token = token
        defaults.set(token?.token, forKey: UserSession.userSessionKey)
    }
}
