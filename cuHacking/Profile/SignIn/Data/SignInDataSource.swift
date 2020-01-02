//
//  SignInDataSource.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
class SignInDataSource: SignInRepository {
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200

    func signIn(email: String, password: String, completionHandler: @escaping (MagnetonAPIObject.UserToken?, Error?) -> Void) {
        let baseURL = SignInDataSource.baseURL + "/users/signin"
        var requestURL = URLRequest(url: URL(string: baseURL)!)
        requestURL.httpMethod = "POST"
        let body: [String: Any] = ["email": email, "password": password]
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        requestURL.httpBody = bodyData
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != SignInDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to login. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }

            let token: MagnetonAPIObject.UserToken?

            do {
                token = try JSONDecoder().decode(MagnetonAPIObject.UserToken.self, from: data)
                completionHandler(token, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
}
