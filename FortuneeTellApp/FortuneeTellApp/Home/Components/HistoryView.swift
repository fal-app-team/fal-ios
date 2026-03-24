import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack {
            Spacer()

            Text("Fal Geçmişi")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.primary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 80)
    }
}

#Preview {
    HistoryView()
}
