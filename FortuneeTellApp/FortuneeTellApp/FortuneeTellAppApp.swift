//
//  FortuneeTellAppApp.swift
//  FortuneeTellApp
//
//  Created by Deniz Metin on 3.03.2026.
//

import SwiftUI

@main
struct FortuneeTellAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
