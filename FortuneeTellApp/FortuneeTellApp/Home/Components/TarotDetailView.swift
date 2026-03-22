import SwiftUI

struct TarotDetailView: View {
    var body: some View {
        VStack {
            Text("Tarot Falı")
                .font(.largeTitle)
                .bold()

            Text("Tarot kartları burada olacak.")
        }
        .navigationTitle("Tarot Falı")
        .navigationBarTitleDisplayMode(.inline)
    }
}
