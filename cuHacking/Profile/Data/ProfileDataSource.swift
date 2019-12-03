//
//  ProfileDataSource.swift
//  cuHacking
//
//  Created by Santos on 2019-09-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
class ProfileDataSource: ProfileRepository {
    func getUserProfile() -> MagnetonAPIObject.UserProfile {
        let blankUser = MagnetonAPIObject.UserProfile(
            operation: "get",
            status: "500",
            data: MagnetonAPIObject.UserProfile.Data(
                username: "",
                role: "",
                uid: "")
        )
        guard let filePath = Bundle.main.path(forResource: "UserProfile", ofType: "json") else {
            return blankUser
        }
        do {
            let url = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: url)
            let userProfile = try JSONDecoder().decode(MagnetonAPIObject.UserProfile.self, from: data)
              
            return userProfile
            
        } catch {
            print("Error: \(error)")
            return blankUser
        }
    }
    
    
}
