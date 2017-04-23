//
//  ContactExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Contacts

extension CNContact {
    var fullName:String {
        return ""
    }
    
    static let ImageKey = "image"
    static let FirstNameKey = "owner_first_name"
    static let LastNameKey = "owner_last_name"
    static let CardNameKey = "name"
    static let CardJSONKey = "json"
    
    var data: [String: Any] {
        var dictionary:[String:Any] = [:];
        
        dictionary["name"] = [
            "prefix": self.namePrefix,
            "given" : self.givenName,
            "middle" : self.middleName,
            "family" : self.familyName,
            "suffix" : self.nameSuffix,
            "nickname" : self.nickname,
            
            "phonetic_given" : self.phoneticGivenName,
            "phonetic_middle" : self.phoneticMiddleName,
            "phonetic_family" : self.phoneticFamilyName,
            "previous_family" : self.previousFamilyName,
        ]
        
        dictionary["organization"] = self.organizationName
        dictionary["department"] = self.departmentName
        dictionary["job_title"] = self.jobTitle
        dictionary["phonetic_organization"] = self.phoneticOrganizationName
        
        var phoneNumbersArray:[[String:Any]] = []
        for phoneNumber in self.phoneNumbers {
            phoneNumbersArray.append(toPhoneNumber(phoneNumber))
        }
        dictionary["phone_numbers"] = phoneNumbersArray
        
        var emailsArray:[[String:Any]] = []
        for email in self.emailAddresses {
            emailsArray.append(toEmail(email))
        }
        dictionary["emails"] = emailsArray
        
        var postalAddressesArray:[[String:Any]] = []
        for postalAddress in self.postalAddresses {
            postalAddressesArray.append(toPostalAddress(postalAddress))
        }
        dictionary["postal_addresses"] = postalAddressesArray
        
        var urlAddressesArray:[[String:Any]] = []
        for urlAddress in self.urlAddresses {
            urlAddressesArray.append(toURLAddress(urlAddress))
        }
        dictionary["urls"] = urlAddressesArray
        
        var socialProfilesArray:[[String:Any]] = []
        for socialProfile in self.socialProfiles {
            socialProfilesArray.append(toSocialProfile(socialProfile))
        }
        dictionary["social_profiles"] = socialProfilesArray
        
        var datesArray:[[String:Any]] = []
        for date in self.dates {
            datesArray.append(toDate(date))
        }
        if let birthday = self.birthday {
            datesArray.append(toDate("birthday", date: birthday))
        }
        if let g_birthday = self.nonGregorianBirthday {
            datesArray.append(toDate("non_gregorian_birthday", date: g_birthday))
        }
        dictionary["dates"] = datesArray
        
        return dictionary
    }
    
    private func toPhoneNumber(_ reference:CNLabeledValue<CNPhoneNumber>) -> [String:Any] {
        let dictionary = [
            "number" : getStringValue(reference.value.stringValue)
        ]
        return [getStringValue(reference.label, defaultValue: "home") : dictionary]
    }
    
    private func toEmail(_ reference:CNLabeledValue<NSString>) -> [String:Any] {
        let dictionary = [
            "email" : getStringValue(reference.value)
        ]
        return [getStringValue(reference.label, defaultValue: "home") : dictionary]
    }
    
    private func toPostalAddress(_ reference:CNLabeledValue<CNPostalAddress>) -> [String:Any] {
        let dictionary = [
            "street" : getStringValue(reference.value.street),
            "city" : getStringValue(reference.value.city),
            "state" : getStringValue(reference.value.state),
            "postal_code" : getStringValue(reference.value.postalCode),
            "country" : getStringValue(reference.value.country),
            "iso_country_code" : getStringValue(reference.value.isoCountryCode)
        ]
        return [getStringValue(reference.label, defaultValue: "home") : dictionary]
    }
    
    private func toURLAddress(_ reference:CNLabeledValue<NSString>) -> [String: Any] {
        let dictionary = [
            "url" : getStringValue(reference.value)
        ]
        return [getStringValue(reference.label, defaultValue: "website") : dictionary]
    }
    
    private func toSocialProfile(_ reference:CNLabeledValue<CNSocialProfile>) -> [String:Any] {
        let dictionary = [
            "url" : getStringValue(reference.value.urlString),
            "username" : getStringValue(reference.value.username),
            "user_identifier" : getStringValue(reference.value.userIdentifier),
            "service" : getStringValue(reference.value.service)
        ]
        return [getStringValue(reference.label, defaultValue: "default") : dictionary]
    }
    
    private func toDate(_ reference:CNLabeledValue<NSDateComponents>) -> [String:Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = CCCard.dateFormat
        
        var calendar = reference.value.calendar
        if calendar != nil {
            calendar = Calendar(identifier: .gregorian)
        }
        
        let dictionary = [
            "date" : getStringValue(formatter.string(from: reference.value.date!)),
            "calendar" : getStringValue(calendar!.identifier, defaultValue: "gregorian")
        ]
        return [getStringValue(reference.label, defaultValue: "date") : dictionary]
    }
    
    private func toDate(_  label:String, date:DateComponents) -> [String:Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = CCCard.dateFormat
        
        var calendar = date.calendar
        if calendar != nil {
            calendar = Calendar(identifier: .gregorian)
        }
        
        let dictionary = [
            "date" : getStringValue(formatter.string(from: date.date!)),
            "calendar" : getStringValue(calendar!.identifier, defaultValue: "gregorian")
        ]
        return [label : dictionary]
    }
}
