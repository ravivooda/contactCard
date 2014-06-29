//
//  MNContact.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContact.h"
#import <malloc/malloc.h>

#define kProfileArchiveKey @"contactArchiveKey"
NSString * const kCustomFileUTI = @"com.mafian.contactProfileUTI.contactProfile";

@interface MNContact ()

@property (nonatomic) ABRecordRef recordRef;

// Identifier of the card
@property (nonatomic) int contactID;

// Images
@property (strong, nonatomic) UIImage *imageOfPerson;
@property (strong, nonatomic) UIImage *backgroundImage;

// Identification i.e. Name
@property (strong, nonatomic) NSString *prefixName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *suffixName;
@property (strong, nonatomic) NSString *nickName;

// Maybe they want to show different details on the card
@property (strong, nonatomic) NSString *firstTitle;
@property (strong, nonatomic) NSString *secondaryTitle;

// Work Details
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *departmentName;

// Phone Number
@property (strong, nonatomic) NSArray *phoneNumbers;

// Email
@property (strong, nonatomic) NSArray *emails;

#warning Some Social Networking links Need to add more or remove
// Social Networking links
@property (strong, nonatomic) NSString *facebookUserName;
@property (strong, nonatomic) NSString *linkedInUserName;
@property (strong, nonatomic) NSString *twitterUserName;

// Website
@property (strong, nonatomic) NSString *website;

// Addresses
//@property (strong, nonatomic) MNAddress *address;

// Notes
@property (strong, nonatomic) NSString *notesOfContact;

@end

@implementation MNContact

#pragma mark - Activity item source implementations
-(id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    return [self securelyArchiveRootObject:self];
}

-(id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [NSData data];
}

-(NSString*) activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return kCustomFileUTI;
}

-(NSString*) activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return @"Transer contact";
}

-(UIImage*) activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
    return nil;
}

- (NSData*) securelyArchiveRootObject:(id) object {
    //Use secure encoding because files could be transfered from anywhere by anyone
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //Ensure that secure encoding is used
    [archiver setRequiresSecureCoding:YES];
    [archiver encodeObject:object forKey:kProfileArchiveKey];
    [archiver finishEncoding];
    
    return data;
}

#pragma mark - Secure Coding Protocol implementations
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:_contactID forKey:@"contactID"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.recordRef = (__bridge ABRecordRef)([aDecoder decodeObjectForKey:@"recordRef"]);
        MNContact *retObject = [self initWithRecordReference:self.recordRef];
        self = retObject;
    }
    return self;
}

+(BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark - Copying Protocol implementations
-(id) copyWithZone:(NSZone *)zone {
    MNContact *retObject = [[[self class] allocWithZone:zone] init];
    if (retObject) {
        retObject.contactID = _contactID;

        retObject.imageOfPerson = [UIImage imageWithCGImage:_imageOfPerson.CGImage];
        retObject.backgroundImage = [UIImage imageWithCGImage:_backgroundImage.CGImage];
        
        retObject.prefixName = [_prefixName copyWithZone:zone];
        retObject.firstName = [_firstName copyWithZone:zone];
        retObject.middleName = [_middleName copyWithZone:zone];
        retObject.lastName = [_lastName copyWithZone:zone];
        retObject.suffixName = [_suffixName copyWithZone:zone];
        retObject.nickName = [_nickName copyWithZone:zone];
        
        retObject.firstTitle = [_firstTitle copyWithZone:zone];
        retObject.secondaryTitle = [_secondaryTitle copyWithZone:zone];
        
        retObject.jobTitle = [_jobTitle copyWithZone:zone];
        retObject.departmentName = [_departmentName copyWithZone:zone];
        retObject.companyName = [_companyName copyWithZone:zone];
        
        retObject.phoneNumbers = [_phoneNumbers copyWithZone:zone];
        retObject.emails = [_emails copyWithZone:zone];
        
        retObject.facebookUserName = [_facebookUserName copyWithZone:zone];
        retObject.twitterUserName = [_twitterUserName copyWithZone:zone];
        retObject.linkedInUserName   = [_linkedInUserName copyWithZone:zone];
        
        retObject.website = [_website copyWithZone:zone];
        
//        retObject.address = [_address copyWithZone:zone];
        
        retObject.notesOfContact = [_notesOfContact copyWithZone:zone];
        
        retObject.recordRef = self.recordRef;
    }
    return retObject;
}
@end
