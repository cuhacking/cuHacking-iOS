//
//  SignInRepository.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
protocol SignInRepository {
    func signIn(email: String, password: String, completionHandler: @escaping (MagnetonAPIObject.UserToken?, Error?) -> Void)
}
