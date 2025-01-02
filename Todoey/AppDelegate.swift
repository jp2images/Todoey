//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?

    /// This is the first function to load when the app starts up. It occurs before the viewDidLlad begins of
    /// the first startup controller.
    /// Override point for customization after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print("application: Did Finish Launching with options")
        
        // *********************************************
        // To locate where the Realm data is stored:
        print(Realm.Configuration.defaultConfiguration.fileURL)
        // Location gets burried into the CoreSim.. like Sqlite does but also adds
        // /default.realm db and need the app: Realm Browser to view
        
        // REALM DB Additions that MUST be replaced. REALM is no longer available.
        // This is Adding data to REALM
//        let data = Data()
//        data.name = "Jeff"
//        data.age = 58
        // Removed to prevent a continuous write in startup.
        
        do {
            let realm = try Realm()
            //Also removed to not write on startup.
//            try realm.write {
//                realm.add(data)
            }
        } catch {
            print("Error initializing realm, \(error)")
        }
        // *********************************************
        
        /// When running in a simulator. This will show the path of our sandbox where the applicaiton is
        /// running. We need the ID of it and the id of the items to show that they are really saved.
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        return true
    }

    /// Sent when the application is about to move from active to inactive state. This can occur for certain
    /// types of temporary interruptions (such as an incoming phone call or SMS message) or when the
    /// user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
    /// Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }

    /// Called when the app disappears off the screen.
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough
    /// application state information to restore your application to its current state in case it is terminated
    /// later.
    /// # If your application supports background execution, this method is
    /// # called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    /// Called as part of the transition from the background to the inactive state; here you can undo many
    /// of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the
    /// application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        //print("applicationDidBecomeActive")
    }

    /// This can be triggered either by th euser or by the
    /// operating system. Called when the application is about to terminate. Save data if appropriate. See
    /// also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        self.saveContext()
    }
    
    //MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container: NSPersistentContainer = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription: NSPersistentStoreDescription, error: (any Error)?) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Core Data Saving support
    func saveContext () {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        
        /// let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}

