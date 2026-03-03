//
//  FortuneTellAppApp.swift
//  FortuneTellApp
//
//  Created by Deniz Metin on 3.03.2026.
//

import SwiftUI

@main
struct FortuneTellAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
