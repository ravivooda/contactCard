//
//  AppDelegate.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static let moreCardsPurchaseProductIdentifier = "premium_card_purchase"
    
    static weak var myContactsViewController:CCMyContactsViewController?
    static weak var myCardsViewController:CCMyCardsViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        // Registering for User Defaults
        UserDefaults.standard.register(defaults: [:])
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let currentViewController = self.window?.currentViewController() {
            LoginCommand(viewController: currentViewController, returnCommand: nil).execute(completed: nil)
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        return self.window?.currentViewController()
    }
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata) {
        print("Accepting new cloud kit share with metadata \(cloudKitShareMetadata)")
        OpenAcceptingContactURLCommand(cloudKitShareMetadata: cloudKitShareMetadata, viewController: self.getCurrentViewController() ?? UIViewController(), returningCommand: nil).execute(completed: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    static func registerForRemoteNotifications() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                print("Error occurred in registering for notification authorization \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    private func convertDeviceTokenToString(deviceToken:Data) -> String {
        var deviceTokenStr = deviceToken.description.replacingOccurrences(of: ">", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: "<", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: " ", with: "")
        
        return deviceTokenStr
    }
    
    static var deviceToken:String?
    static var registerDevicePostCommand:Command?
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppDelegate.deviceToken = convertDeviceTokenToString(deviceToken: deviceToken)
        if let postCommand = AppDelegate.registerDevicePostCommand {
            postCommand.execute(completed: nil)
        }
        if let user = LoginCommand.user, let deviceToken = AppDelegate.deviceToken {
            print("Remote Notifications are enabled with device token: \(deviceToken)")
            Data.registerDevice(userID: user.id, deviceToken: AppDelegate.deviceToken!, success: { (response) in
                print("Successfully register device for user \(user.id)")
            }, fail: { (response, HTTPResponse) in
                print("Failed to register device token remotely \(HTTPResponse)")
            })
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error \(error)")
        AppDelegate.deviceToken = ""
        if let postCommand = AppDelegate.registerDevicePostCommand {
            postCommand.execute(completed: nil)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("User Info: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("User Info 2: \(userInfo)")
        completionHandler(.noData)
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Utils.Contact_Card" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Contact_Card", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

