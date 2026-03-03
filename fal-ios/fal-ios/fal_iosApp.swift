//
//  fal_iosApp.swift
//  fal-ios
//
//  Created by aymina on 3.03.2026.
//

import SwiftUI

@main
struct fal_iosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
