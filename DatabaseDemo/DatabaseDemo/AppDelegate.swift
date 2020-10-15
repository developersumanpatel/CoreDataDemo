//
//  AppDelegate.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var persistentContainer: NSPersistentContainer!
    
    private let appContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatabaseDemo")
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        createPersistanceContainer()
        return true
    }


    // MARK: - Core Data stack

    func createPersistanceContainer() {
        appContainer.loadPersistentStores { _, error in
            if error == nil {
                self.appContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                self.appContainer.viewContext.undoManager = nil
                self.appContainer.viewContext.automaticallyMergesChangesFromParent = true
                self.persistentContainer = self.appContainer
            } else {
                debugPrint("Error \(String(describing: error))")
            }
        }
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

