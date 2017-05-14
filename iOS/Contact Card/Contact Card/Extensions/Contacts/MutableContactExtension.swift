//
//  MutableContactExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Contacts
import CloudKit
import UIKit

extension CNMutableContact {
    convenience init(withRecord record:CKRecord) {
        self.init()
        if let jsonString = record["json"] as? String, let dictionary = convertToDictionary(text: jsonString) {
            self.parse(payload: dictionary)
        }
        
        // Image Data
        if let asset = record[CNContact.ImageKey] as? CKAsset, let data = NSData(contentsOf: asset.fileURL) as Foundation.Data?, let _ = UIImage(data: data) {
            self.imageData = data
        }
        
        self.setupContactIdentifier(record: record)
    }
    
    func parse(payload:[String: Any]) {
        if let nameDict = payload["name"] as? [String: Any] {
            self.namePrefix = getStringValue(nameDict["prefix"])
            self.givenName = getStringValue(nameDict["given"])
            self.middleName = getStringValue(nameDict["middle"])
            self.familyName = getStringValue(nameDict["family"])
            self.nameSuffix = getStringValue(nameDict["suffix"])
            self.nickname = getStringValue(nameDict["nickname"])
            
            self.phoneticGivenName = getStringValue(nameDict["phonetic_given"])
            self.phoneticMiddleName = getStringValue(nameDict["phonetic_middle"])
            self.phoneticFamilyName = getStringValue(nameDict["phonetic_family"])
            self.previousFamilyName = getStringValue(nameDict["previous_family"])
        }
        
        self.organizationName = getStringValue(payload["organization"])
        self.departmentName = getStringValue(payload["department"])
        self.jobTitle = getStringValue(payload["job_title"])
        self.phoneticOrganizationName = getStringValue(payload["phonetic_organization"])
        
        //TODO: Fix image and thumbnail
        
        if let phoneNumbersDict = payload["phone_numbers"] as? [[String: [String:String]]] {
            var phoneNumbersArray:[CNLabeledValue<CNPhoneNumber>] = []
            for phoneNumberDict in phoneNumbersDict {
                if let phoneNumber = getPhoneNumber(payload: phoneNumberDict) {
                    phoneNumbersArray.append(phoneNumber)
                }
            }
            self.phoneNumbers = phoneNumbersArray
        }
        
        if let emailsDict = payload["emails"] as? [[String: [String:String]]] {
            var emailsArray:[CNLabeledValue<NSString>] = []
            for emailDict in emailsDict {
                if let email = getEmail(payload: emailDict) {
                    emailsArray.append(email)
                }
            }
            self.emailAddresses = emailsArray
        }
        
        if let postalsDict = payload["postal_addresses"] as? [[String: [String:String]]] {
            var postalsArray:[CNLabeledValue<CNPostalAddress>] = []
            for postalDict in postalsDict {
                if let postal = getPostalAddress(payload: postalDict) {
                    postalsArray.append(postal)
                }
            }
            self.postalAddresses = postalsArray
        }
        
        if let urlsDict = payload["urls"] as? [[String: [String:String]]] {
            var urlsArray:[CNLabeledValue<NSString>] = []
            for urlDict in urlsDict {
                if let url = getURLAddress(payload: urlDict) {
                    urlsArray.append(url)
                }
            }
            self.urlAddresses = urlsArray
        }
        
        if let socialsDict = payload["social_profiles"] as? [[String: [String:String]]] {
            var socialsArray:[CNLabeledValue<CNSocialProfile>] = []
            for socialDict in socialsDict {
                if let social = getSocialProfiles(payload: socialDict) {
                    socialsArray.append(social)
                }
            }
            self.socialProfiles = socialsArray
        }
        
        if let datesDict = payload["dates"] as? [[String: [String:String]]] {
            let formatter = DateFormatter()
            formatter.dateFormat = CCCard.dateFormat
            var datesArray:[CNLabeledValue<NSDateComponents>] = []
            
            for dateDict in datesDict {
                if let key = dateDict.keys.first, let value = dateDict.values.first {
                    if key == "birthday" {
                        if let dateComponent = getDate(payload: value) {
                            self.birthday = dateComponent
                        }
                    } else if key == "non_gregorian_birthday" {
                        if let dateComponent = getDate(payload: value) {
                            self.nonGregorianBirthday = dateComponent
                        }
                    } else {
                        if let dateComponents = getDate(payload: value) {
                            datesArray.append(CNLabeledValue(label: key, value: dateComponents as NSDateComponents))
                        }
                    }
                }
            }
            self.dates = datesArray
        }
    }
    
    public func setupContactIdentifier(record:CKRecord) {
        var notes = [String]()
        for line in self.note.components(separatedBy: "\n") {
            if !line.contains(CCContact.referenceKey) {
                notes.append(line)
            }
        }
        notes.append("\(CCContact.referenceKey)\(record.recordIdentifier)/\(record.recordChangeTag ?? "")")
        
        self.note = notes.joined(separator: "\n")
    }
    
    private func getPhoneNumber(payload:[String : [String:String]]) -> CNLabeledValue<CNPhoneNumber>? {
        for (key, value) in payload {
            if let phoneNumber = value["number"] {
                return CNLabeledValue(label: key, value: CNPhoneNumber(stringValue: phoneNumber))
            }
        }
        return nil
    }
    
    private func getEmail(payload:[String : [String:String]]) -> CNLabeledValue<NSString>? {
        for (key,value) in payload {
            if let email = value["email"] {
                return CNLabeledValue(label: key, value: email as NSString)
            }
        }
        return nil
    }
    
    private func getPostalAddress(payload:[String:[String:String]]) -> CNLabeledValue<CNPostalAddress>? {
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
    
    private func getURLAddress(payload:[String:[String:String]]) -> CNLabeledValue<NSString>? {
        for (key, value) in payload {
            if let url = value["url"] {
                return CNLabeledValue(label: key, value: url as NSString)
            }
        }
        return nil
    }
    
    private func getSocialProfiles(payload:[String:[String:String]]) -> CNLabeledValue<CNSocialProfile>? {
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
    
    private func getDate(payload:[String : String]) -> DateComponents? {
        let calendarType = getStringValue(payload["calendar"], defaultValue: "gregorian")
        let dateString = getStringValue(payload["date"])
        
        let formatter = DateFormatter()
        formatter.dateFormat = CCCard.dateFormat
        
        if let key = (CNMutableContact.calendarMap as NSDictionary).allKeys(for: calendarType).first as? Calendar.Identifier, let date = formatter.date(from: dateString) {
            let calendar = Calendar(identifier: key)
            return calendar.dateComponents([.year, .month, .day], from: date)
        }
        return nil
    }
}
