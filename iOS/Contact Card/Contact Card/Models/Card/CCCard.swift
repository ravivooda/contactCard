//
//  CCCard.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Contacts

class CCCard {
    static let dateFormat = "yyyy/MM/dd hh:mm Z"

    let id:Int
    
    let contact:CNContact
    
    init(id:Int, contact:CNContact) {
        self.id = id
        self.contact = contact
    }
    
    static func toData(_ contact:CNContact, imageURL:String?, thumbImageURL:String?) -> [String: Any] {
        var dictionary:[String:Any] = [:];
        
        dictionary["name"] = [
            "prefix": getStringValue(contact.namePrefix),
            "given" : getStringValue(contact.givenName),
            "middle" : getStringValue(contact.middleName),
            "family" : getStringValue(contact.familyName),
            "suffix" : getStringValue(contact.nameSuffix),
            "nickname" : getStringValue(contact.nickname),
            
            "phonetic_given" : getStringValue(contact.phoneticGivenName),
            "phonetic_middle" : getStringValue(contact.phoneticMiddleName),
            "phonetic_family" : getStringValue(contact.phoneticFamilyName),
            "previous_family" : getStringValue(contact.previousFamilyName),
        ]
        
        dictionary["organization"] = getStringValue(contact.organizationName)
        dictionary["department"] = getStringValue(contact.departmentName)
        dictionary["job_title"] = getStringValue(contact.jobTitle)
        dictionary["phonetic_organization"] = getStringValue(contact.phoneticOrganizationName)
        
        dictionary["image"] = getStringValue(imageURL)
        dictionary["thumbnail"] = getStringValue(thumbImageURL)
        
        var phoneNumbersArray:[[String:Any]] = []
        for phoneNumber in contact.phoneNumbers {
            phoneNumbersArray.append(toPhoneNumber(phoneNumber))
        }
        dictionary["phone_numbers"] = phoneNumbersArray
        
        var emailsArray:[[String:Any]] = []
        for email in contact.emailAddresses {
            emailsArray.append(toEmail(email))
        }
        dictionary["emails"] = emailsArray
        
        var postalAddressesArray:[[String:Any]] = []
        for postalAddress in contact.postalAddresses {
            postalAddressesArray.append(toPostalAddress(postalAddress))
        }
        dictionary["postal_addresses"] = postalAddressesArray
        
        var urlAddressesArray:[[String:Any]] = []
        for urlAddress in contact.urlAddresses {
            urlAddressesArray.append(toURLAddress(urlAddress))
        }
        dictionary["urls"] = urlAddressesArray
        
        var socialProfilesArray:[[String:Any]] = []
        for socialProfile in contact.socialProfiles {
            socialProfilesArray.append(toSocialProfile(socialProfile))
        }
        dictionary["social_profiles"] = socialProfilesArray
        
        var datesArray:[[String:Any]] = []
        for date in contact.dates {
            datesArray.append(toDate(date))
        }
        if let birthday = contact.birthday {
            datesArray.append(toDate("birthday", date: birthday))
        }
        if let g_birthday = contact.nonGregorianBirthday {
            datesArray.append(toDate("non_gregorian_birthday", date: g_birthday))
        }
        dictionary["dates"] = datesArray
        
        return dictionary
    }
    
    private static func toPhoneNumber(_ reference:CNLabeledValue<CNPhoneNumber>) -> [String:Any] {
        let dictionary = [
            "number" : getStringValue(reference.value.stringValue)
        ]
        return [getStringValue(reference.label, defaultValue: "home") : dictionary]
    }
    
    private static func toEmail(_ reference:CNLabeledValue<NSString>) -> [String:Any] {
        let dictionary = [
            "email" : getStringValue(reference.value)
        ]
        return [getStringValue(reference.label, defaultValue: "home") : dictionary]
    }
    
    private static func toPostalAddress(_ reference:CNLabeledValue<CNPostalAddress>) -> [String:Any] {
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
    
    private static func toURLAddress(_ reference:CNLabeledValue<NSString>) -> [String: Any] {
        let dictionary = [
            "url" : getStringValue(reference.value)
        ]
        return [getStringValue(reference.label, defaultValue: "website") : dictionary]
    }
    
    private static func toSocialProfile(_ reference:CNLabeledValue<CNSocialProfile>) -> [String:Any] {
        let dictionary = [
            "url" : getStringValue(reference.value.urlString),
            "username" : getStringValue(reference.value.username),
            "user_identifier" : getStringValue(reference.value.userIdentifier),
            "service" : getStringValue(reference.value.service)
        ]
        return [getStringValue(reference.label, defaultValue: "default") : dictionary]
    }
    
    private static func toDate(_ reference:CNLabeledValue<NSDateComponents>) -> [String:Any] {
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
    
    private static func toDate(_  label:String, date:DateComponents) -> [String:Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = CCCard.dateFormat
        let dictionary = [
            "date" : getStringValue(formatter.string(from: date.date!))
        ]
        return [label : dictionary]
    }
}
