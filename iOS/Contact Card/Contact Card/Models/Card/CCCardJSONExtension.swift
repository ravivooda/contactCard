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
    convenience init(payload:[String : AnyObject]) {
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
        
        if let phoneNumbersDict = payload["phone_numbers"] as? [String: Any] {
            contact.phoneNumbers = CCCard.getPhoneNumbers(payload: phoneNumbersDict)
        }
        
        if let emailsDict = payload["emails"] as? [String: Any] {
            contact.emailAddresses = CCCard.getEmails(payload: emailsDict)
        }
        
        
        if let datesDict = payload["dates"] as? [String: Any] {
            let formatter = DateFormatter()
            formatter.dateFormat = CCCard.dateFormat
            var datesArray:[CNLabeledValue<NSDateComponents>] = []
            for (key, value) in datesDict {
                if let dateDict = value as? [String : String] {
                    if key == "birthday" {
                        if let dateComponent = CCCard.getDate(payload: dateDict) {
                            contact.birthday = dateComponent
                        }
                    } else if key == "non_gregorian_birthday" {
                        if let dateComponent = CCCard.getDate(payload: dateDict) {
                            contact.nonGregorianBirthday = dateComponent
                        }
                    } else {
                        if let dateComponents = CCCard.getDate(payload: dateDict) {
                            datesArray.append(CNLabeledValue(label: key, value: dateComponents as NSDateComponents))
                        }
                    }
                }
            }
        }
        
        self.init(contact: contact)
    }
    
    private static func getPhoneNumbers(payload:[String:Any]) -> [CNLabeledValue<CNPhoneNumber>] {
        var retArray:[CNLabeledValue<CNPhoneNumber>] = []
        for (key, value) in payload {
            if let phoneDict = value as? [String: String] {
                if let phoneNumber = phoneDict["number"] {
                    retArray.append(CNLabeledValue(label: key, value: CNPhoneNumber(stringValue: phoneNumber)))
                }
            }
        }
        return retArray
    }
    
    private static func getEmails(payload:[String:Any]) -> [CNLabeledValue<NSString>] {
        var retArray:[CNLabeledValue<NSString>] = []
        for (key,value) in payload {
            if let emailDict = value as? [String: String] {
                if let email = emailDict["email"] {
                    retArray.append(CNLabeledValue(label: key, value: email as NSString))
                }
            }
        }
        return retArray
    }
    
    private static func getPostalAddresses(payload:[String:Any]) -> [CNLabeledValue<CNPostalAddress>] {
        var retArray:[CNLabeledValue<CNPostalAddress>] = []
        for (key, value) in payload {
            if let postalDict = value as? [String: String] {
                let postal = CNMutablePostalAddress()
                postal.street = getStringValue(postalDict["street"])
                postal.city = getStringValue(postalDict["city"])
                postal.state = getStringValue(postalDict["state"])
                postal.postalCode = getStringValue(postalDict["postal_code"])
                postal.country = getStringValue(postalDict["country"])
                postal.isoCountryCode = getStringValue(postalDict["iso_country_code"])
                
                retArray.append(CNLabeledValue(label: key, value: postal))
            }
        }
        return retArray
    }
    
    private static func getURLAddresses(payload:[String:Any]) -> [CNLabeledValue<NSString>] {
        var retArray:[CNLabeledValue<NSString>] = []
        for (key, value) in payload {
            if let urlDict = value as? [String : String] {
                if let url = urlDict["url"] {
                    retArray.append(CNLabeledValue(label: key, value: url as NSString))
                }
            }
        }
        return retArray
    }
    
    private static func getSocialProfiles(payload:[String:Any]) -> [CNLabeledValue<CNSocialProfile>] {
        var retArray:[CNLabeledValue<CNSocialProfile>] = []
        for (key, value) in payload {
            if let socialDict = value as? [String : String] {
                let url = getStringValue(socialDict["url"])
                let username = getStringValue(socialDict["username"])
                let userIdentifier = getStringValue(socialDict["user_identifier"])
                let service = getStringValue(socialDict["service"])
                retArray.append(CNLabeledValue(label: key, value: CNSocialProfile(urlString: url, username: username, userIdentifier: userIdentifier, service: service)))
            }
        }
        return retArray
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
