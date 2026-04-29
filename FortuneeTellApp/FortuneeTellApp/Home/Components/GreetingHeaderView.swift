import SwiftUI

struct GreetingHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) { //elemanları yan yana dizer
                Text("İyi günler!")
                    .font(.system(size: 26, weight: .bold))
            }

            Text("Bugün hangi yolculuğa çıkmak istersin?")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GreetingHeaderView()
        .padding()
}
