//
//  ProfileDataSource.swift
//  cuHacking
//
//  Created by Santos on 2019-09-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
class ProfileDataSource: ProfileRepository {
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200
    struct Header {
        static let AUTHORIZATION = "Authorization"
        static let BEARER = "Bearer "
    }
    func getUserProfile(token: String, completionHandler: @escaping (MagnetonAPIObject.UserProfile?, Error?) -> Void) {
        let baseURL = ProfileDataSource.baseURL + "/users/profile"
        let y = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImNlNWNlZDZlNDBkY2QxZWZmNDA3MDQ4ODY3YjFlZDFlNzA2Njg2YTAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY3VoYWNraW5nLTI0MzcxMiIsImF1ZCI6ImN1aGFja2luZy0yNDM3MTIiLCJhdXRoX3RpbWUiOjE1Nzc5OTU2OTUsInVzZXJfaWQiOiJaZWkxSmpoSTVIZnNNQUI0WlY5aUZJdnJKN0UzIiwic3ViIjoiWmVpMUpqaEk1SGZzTUFCNFpWOWlGSXZySjdFMyIsImlhdCI6MTU3Nzk5NTY5NSwiZXhwIjoxNTc3OTk5Mjk1LCJlbWFpbCI6InNhbnRvc2dhZ2JlZ25vbkBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsic2FudG9zZ2FnYmVnbm9uQGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.pxumNV4OE3Mx1xlDGTPx4NOcHQWhUc3phWjqpNTmDqEOoS7g3ayEBFinEZ8rCFQJBeRPwVKHIqvKoAZdr3cS2ctshmta9Ngayv72OfJNVM-jgzSbqDo4lc10vgDjQ2U_7epd_bFEbHEA4TZvQxjTlRsHyMeE0l2vWKVLjsRl2gyNV5qMSdfXt9P0b2tsZi9GR4x18kdjuqdrii0SMl_b8dKg7HeFsRGLtK0E4d9lxcM6iIhOhvbD8HnXFKJeGkFutnFe4_hjtdRQ1ugC3kG0h7VVms6H_Mkc-ASa-IlF3IFd9PknFfqygQfvbWiJ7c6LhwprC2knssYRF7kEJ1KGvQ"
        var requestURL = URLRequest(url: URL(string: baseURL)!)
        requestURL.httpMethod = "GET"
        requestURL.allHTTPHeaderFields = [Header.AUTHORIZATION: Header.BEARER + y]

        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != ProfileDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch profile. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            let profile: MagnetonAPIObject.UserProfile?

            do {
                profile = try JSONDecoder().decode(MagnetonAPIObject.UserProfile.self, from: data)
                completionHandler(profile, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
}
    
    
//    func getUserProfile() -> MagnetonAPIObject.UserProfile {
//        let blankUser = MagnetonAPIObject.UserProfile(
//            operation: "get",
//            status: "500",
//            data: MagnetonAPIObject.UserProfile.Data(
//                username: "",
//                role: "",
//                uid: "")
//        )
//        guard let filePath = Bundle.main.path(forResource: "UserProfile", ofType: "json") else {
//            return blankUser
//        }
//        do {
//            let url = URL(fileURLWithPath: filePath)
//            let data = try Data(contentsOf: url)
//            let userProfile = try JSONDecoder().decode(MagnetonAPIObject.UserProfile.self, from: data)
//
//            return userProfile
//
//        } catch {
//            print("Error: \(error)")
//            return blankUser
//        }
//    }
    
//}
