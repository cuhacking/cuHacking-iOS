//
//  UserProfile.swift
//  cuHacking
//
//  Created by Santos on 2019-11-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//
/*
 
 {
     "operation": "get",
     "status": "success",
     "data": {
         "role": "admin",
         "application": {
             "basicInfo": {
                 "gender": "Prefer not to answer",
                 "firstName": null,
                 "ethnicity": "Prefer not to answer",
                 "emergencyPhone": null,
                 "otherEthnicity": null,
                 "lastName": null,
                 "otherGender": null
             },
             "profile": {
                 "resume": false,
                 "linkedin": null,
                 "website": null,
                 "soughtPosition": "Internship (Co-op)",
                 "github": null
             },
             "personalInfo": {
                 "major": null,
                 "minor": null,
                 "expectedGraduation": 2020,
                 "degree": "Bachelor",
                 "cityOfOrigin": null,
                 "tShirtSize": null,
                 "wantsShuttle": false,
                 "otherSchool": null,
                 "school": "Carleton University",
                 "dietaryRestrictions": {
                     "other": null,
                     "glutenFree": false,
                     "lactoseFree": false,
                     "nutFree": false,
                     "vegetarian": false,
                     "halal": false
                 }
             },
             "terms": {
                 "privacyPolicy": false,
                 "under18": false,
                 "codeOfConduct": false
             },
             "skills": {
                 "challengeStatement": null,
                 "accomplishmentStatement": null,
                 "selfTitle": null,
                 "numHackathons": 0
             }
         },
         "review": {
             "wave": 3
         },
         "email": "santosgagbegnon@gmail.com",
         "rsvp": {},
         "appStatus": "unstarted"
     }
 }
 
 */
import Foundation
struct MagnetonAPIObject {
    struct UserProfile: Codable {
        let operation: String
        let status: String
        let data: MagnetonAPIObject.Data
    }
    struct Data: Codable {
        let role: String
        let application: Application
        let review: Review
        let email: String
        let rsvp: [String:String]
        let appStatus: String
    }
    struct Application: Codable {
        let basicInfo: BasicInfo
        let profile: Profile
        let personalInfo: PersonalInfo
        let terms: Terms
        let skills: Skills
    }
    struct BasicInfo: Codable {
        let gender: String?
        let firstName: String?
        let ethnicity: String?
        let emergencyPhone: String?
        let otherEthnicity: String?
        let lastName: String?
        let otherGender: String?
    }
    
    struct Profile: Codable {
        let resume: Bool
        let website: String?
        let soughtPosition: String?
        let github: String?
    }

    struct PersonalInfo: Codable {
        let major: String?
        let minor: String?
        let expectedGraduation: Int
        let degree: String?
        let cityOfOrigin: String?
        let tShirtSize: String?
        let wantsShuttle: Bool
        let school: String?
    }
    
    struct DietaryRestrictions: Codable {
        let other: String?
        let glutenFree: Bool
        let lactoseFree: Bool
        let nutFree: Bool
        let vegetarian: Bool
        let halal: Bool
    }
    
    struct Terms: Codable {
        let privacyPolicy: Bool
        let under18: Bool
        let codeOfConduct: Bool
    }
    
    struct Skills: Codable {
        let challengeStatement: String?
        let accomplishmentStatement: String?
        let selfTitle: String?
        let numHackathons: Int
    }
    
    struct Review: Codable {
        let wave: Int
    }
}

