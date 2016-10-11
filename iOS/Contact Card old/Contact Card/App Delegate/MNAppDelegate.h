//
//  MNAppDelegate.h
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Ravi Vooda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
