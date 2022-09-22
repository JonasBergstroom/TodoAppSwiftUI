//
//  CoreDataManager.swift
//  TodoAppSwiftUI
//
//  Created by Jonas Bergström on 2022-09-22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "TodoAppModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to init Core Data \(error)")
            }
        }
    }
}
