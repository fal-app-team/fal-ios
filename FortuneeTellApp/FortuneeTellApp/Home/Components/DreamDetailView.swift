import SwiftUI

struct DreamDetailView: View {
    var body: some View {
        VStack {
            Text("Rüya Yorumu")
                .font(.largeTitle)
                .bold()

            Text("Rüyaların burada yorumlanacak.")
        }
        .navigationTitle("Rüya Yorumu")
        .navigationBarTitleDisplayMode(.inline)
    }
}
