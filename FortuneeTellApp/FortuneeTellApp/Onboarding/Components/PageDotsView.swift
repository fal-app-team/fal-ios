import SwiftUI

struct PageDotsView: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<total, id: \.self) { i in
                Circle()
                    .fill(i == current ? Color.purple : Color.gray.opacity(0.35))
                    .frame(width: i == current ? 9 : 7, height: i == current ? 9 : 7)
                    .scaleEffect(i == current ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
        .padding(.bottom, 6)
    }
}

#Preview {
    VStack(spacing: 20) {
        PageDotsView(current: 0, total: 5)
        PageDotsView(current: 2, total: 5)
        PageDotsView(current: 4, total: 5)
    }
    .padding()
}
