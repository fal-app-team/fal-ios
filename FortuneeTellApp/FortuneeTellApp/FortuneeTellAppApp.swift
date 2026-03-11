import SwiftUI
import FirebaseCore

@main
struct FortuneeTellAppApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
