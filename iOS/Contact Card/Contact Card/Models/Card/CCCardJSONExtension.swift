//
//  CCCardJSONExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import Contacts

extension CCCard {
    convenience init(id:Int, payload:[String : Any]) {
        let contact = CNMutableContact()
        if let nameDict = payload["name"] as? [String: Any] {
            contact.namePrefix = getStringValue(nameDict["prefix"])
            contact.givenName = getStringValue(nameDict["given"])
            contact.middleName = getStringValue(nameDict["middle"])
            contact.familyName = getStringValue(nameDict["family"])
            contact.nameSuffix = getStringValue(nameDict["suffix"])
            contact.nickname = getStringValue(nameDict["nickname"])
            
            contact.phoneticGivenName = getStringValue(nameDict["phonetic_given"])
            contact.phoneticMiddleName = getStringValue(nameDict["phonetic_middle"])
            contact.phoneticFamilyName = getStringValue(nameDict["phonetic_family"])
            contact.previousFamilyName = getStringValue(nameDict["previous_family"])
        }
        
        contact.organizationName = getStringValue(payload["organization"])
        contact.departmentName = getStringValue(payload["department"])
        contact.jobTitle = getStringValue(payload["job_title"])
        contact.phoneticOrganizationName = getStringValue(payload["phonetic_organization"])
        
        //TODO: Fix image and thumbnail
        
        if let phoneNumbersDict = payload["phone_numbers"] as? [[String: [String:String]]] {
            var phoneNumbersArray:[CNLabeledValue<CNPhoneNumber>] = []
            for phoneNumberDict in phoneNumbersDict {
                if let phoneNumber = CCCard.getPhoneNumber(payload: phoneNumberDict) {
                    phoneNumbersArray.append(phoneNumber)
                }
            }
            contact.phoneNumbers = phoneNumbersArray
        }
        
        if let emailsDict = payload["emails"] as? [[String: [String:String]]] {
            var emailsArray:[CNLabeledValue<NSString>] = []
            for emailDict in emailsDict {
                if let email = CCCard.getEmail(payload: emailDict) {
                    emailsArray.append(email)
                }
            }
            contact.emailAddresses = emailsArray
        }
        
        if let postalsDict = payload["postal_addresses"] as? [[String: [String:String]]] {
            var postalsArray:[CNLabeledValue<CNPostalAddress>] = []
            for postalDict in postalsDict {
                if let postal = CCCard.getPostalAddress(payload: postalDict) {
                    postalsArray.append(postal)
                }
            }
            contact.postalAddresses = postalsArray
        }
        
        if let urlsDict = payload["urls"] as? [[String: [String:String]]] {
            var urlsArray:[CNLabeledValue<NSString>] = []
            for urlDict in urlsDict {
                if let url = CCCard.getURLAddress(payload: urlDict) {
                    urlsArray.append(url)
                }
            }
            contact.urlAddresses = urlsArray
        }
        
        if let socialsDict = payload["social_profiles"] as? [[String: [String:String]]] {
            var socialsArray:[CNLabeledValue<CNSocialProfile>] = []
            for socialDict in socialsDict {
                if let social = CCCard.getSocialProfiles(payload: socialDict) {
                    socialsArray.append(social)
                }
            }
            contact.socialProfiles = socialsArray
        }
        
        if let datesDict = payload["dates"] as? [[String: [String:String]]] {
            let formatter = DateFormatter()
            formatter.dateFormat = CCCard.dateFormat
            var datesArray:[CNLabeledValue<NSDateComponents>] = []
            
            for dateDict in datesDict {
                if let key = dateDict.keys.first, let value = dateDict.values.first {
                    if key == "birthday" {
                        if let dateComponent = CCCard.getDate(payload: value) {
                            contact.birthday = dateComponent
                        }
                    } else if key == "non_gregorian_birthday" {
                        if let dateComponent = CCCard.getDate(payload: value) {
                            contact.nonGregorianBirthday = dateComponent
                        }
                    } else {
                        if let dateComponents = CCCard.getDate(payload: value) {
                            datesArray.append(CNLabeledValue(label: key, value: dateComponents as NSDateComponents))
                        }
                    }
                }
            }
            contact.dates = datesArray
        }
        
        self.init(id: id, contact: contact)
    }
    
    private static func getPhoneNumber(payload:[String : [String:String]]) -> CNLabeledValue<CNPhoneNumber>? {
        for (key, value) in payload {
            if let phoneNumber = value["number"] {
                return CNLabeledValue(label: key, value: CNPhoneNumber(stringValue: phoneNumber))
            }
        }
        return nil
    }
    
    private static func getEmail(payload:[String : [String:String]]) -> CNLabeledValue<NSString>? {
        for (key,value) in payload {
            if let email = value["email"] {
                return CNLabeledValue(label: key, value: email as NSString)
            }
        }
        return nil
    }
    
    private static func getPostalAddress(payload:[String:[String:String]]) -> CNLabeledValue<CNPostalAddress>? {
        for (key, value) in payload {
            let postal = CNMutablePostalAddress()
            postal.street = getStringValue(value["street"])
            postal.city = getStringValue(value["city"])
            postal.state = getStringValue(value["state"])
            postal.postalCode = getStringValue(value["postal_code"])
            postal.country = getStringValue(value["country"])
            postal.isoCountryCode = getStringValue(value["iso_country_code"])
            
            return CNLabeledValue(label: key, value: postal)
        }
        return nil
    }
    
    private static func getURLAddress(payload:[String:[String:String]]) -> CNLabeledValue<NSString>? {
        for (key, value) in payload {
            if let url = value["url"] {
                return CNLabeledValue(label: key, value: url as NSString)
            }
        }
        return nil
    }
    
    private static func getSocialProfiles(payload:[String:[String:String]]) -> CNLabeledValue<CNSocialProfile>? {
        for (key, value) in payload {
            let url = getStringValue(value["url"])
            let username = getStringValue(value["username"])
            let userIdentifier = getStringValue(value["user_identifier"])
            let service = getStringValue(value["service"])
            return CNLabeledValue(label: key, value: CNSocialProfile(urlString: url, username: username, userIdentifier: userIdentifier, service: service))
        }
        return nil
    }
    
    static let calendarMap = [
        Calendar.Identifier.gregorian : "gregorian",
        Calendar.Identifier.buddhist : "buddhist",
        Calendar.Identifier.chinese : "chinese",
        Calendar.Identifier.coptic : "coptic",
        Calendar.Identifier.ethiopicAmeteMihret : "ethiopicAmeteMihret",
        Calendar.Identifier.ethiopicAmeteAlem : "ethiopicAmeteAlem",
        Calendar.Identifier.hebrew : "hebrew",
        Calendar.Identifier.iso8601 : "iso8601",
        Calendar.Identifier.indian : "indian",
        Calendar.Identifier.islamic : "islamic",
        Calendar.Identifier.islamicCivil : "islamicCivil",
        Calendar.Identifier.japanese : "japanese",
        Calendar.Identifier.persian : "persian",
        Calendar.Identifier.republicOfChina : "republicOfChina",
        Calendar.Identifier.islamicTabular : "islamicTabular",
        Calendar.Identifier.islamicUmmAlQura : "islamicUmmAlQura"
    ]
    
    private static func getDate(payload:[String : String]) -> DateComponents? {
        let calendarType = getStringValue(payload["calendar"], defaultValue: "gregorian")
        let dateString = getStringValue(payload["date"])
        
        let formatter = DateFormatter()
        formatter.dateFormat = CCCard.dateFormat
        
        if let key = (calendarMap as NSDictionary).allKeys(for: calendarType).first as? Calendar.Identifier, let date = formatter.date(from: dateString) {
            let calendar = Calendar(identifier: key)
            return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        }
        return nil
    }
}
