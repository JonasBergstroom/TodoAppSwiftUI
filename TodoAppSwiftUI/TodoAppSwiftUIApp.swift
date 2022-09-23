//
//  TodoAppSwiftUIApp.swift
//  TodoAppSwiftUI
//
//  Created by Jonas Bergström on 2022-09-22.
//

import SwiftUI

@main
struct TodoAppSwiftUIApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
