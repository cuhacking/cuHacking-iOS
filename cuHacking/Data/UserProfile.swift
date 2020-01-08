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
import UIKit
struct MagnetonAPIObject {

    struct UserProfile: Codable {
        let operation: String
        let status: String
        let data: MagnetonAPIObject.Data
    }
    struct Data: Codable {
        let role: String
        let color: String
        let application: Application
        let review: Review
        let email: String
        let rsvp: [String: String]
        let appStatus: String

        var badgeColor: UIColor {
            switch color {
            case "red":
                return UIColor.red
            case "green":
                return UIColor.green
            case "blue":
                return UIColor.blue
            case "yellow":
                return UIColor.yellow
            default:
                return UIColor.black
            }
        }
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
        let dietaryRestrictions: DietaryRestrictions
    }
    
    struct DietaryRestrictions: Codable {
        let other: String?
        let glutenFree: Bool
        let lactoseFree: Bool
        let nutFree: Bool
        let vegetarian: Bool
        let halal: Bool
        
        var formattedRestrictions: NSMutableAttributedString {
            let attributedString = NSMutableAttributedString()
            var commonRestrictions = "None"
            if lactoseFree {
                commonRestrictions = "Lactose Free\n"
            }
            if nutFree {
                commonRestrictions += "Nut Free\n"
            }
            if vegetarian {
                commonRestrictions += "Vegetarian\n"
            }
            if halal {
                commonRestrictions += "Halal\n"
            }
            if glutenFree {
                commonRestrictions += "Gluten Free"
            }
 
            let commonAttributedRestrictions = NSAttributedString(string: commonRestrictions,
                                                                  attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .bold)]
                                                                 )
            attributedString.append(commonAttributedRestrictions)
            
            if let otherRestrictions = other {
                let attributedOther = "\nOther: \(otherRestrictions)"
                attributedString.append(NSAttributedString(string: attributedOther))
            }
            return attributedString
        }
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

