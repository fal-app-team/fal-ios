import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Ana Sayfa"
    case coffee = "Kahve"
    case tarot = "Tarot"
    case dream = "Rüya"
    case history = "Geçmiş"

    var icon: String {
        switch self {
        case .home: return "house"
        case .coffee: return "cup.and.saucer"
        case .tarot: return "sparkles"
        case .dream: return "moon"
        case .history: return "clock.arrow.circlepath"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22, weight: .medium))

                        Text(tab.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(selectedTab == tab ? Color.purple : Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.purple.opacity(0.16))
                            } else {
                                Color.clear
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal, 18)
        .padding(.bottom, 8)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        CustomTabBar(selectedTab: .constant(.home))
    }
}
