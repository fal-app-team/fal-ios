import SwiftUI
import Foundation

extension Notification.Name {
static let fortuneHistoryShouldRefresh = Notification.Name("fortuneHistoryShouldRefresh")
}

struct HomeView: View {
@State private var selectedTab: TabItem = .home
@StateObject private var historyStore = FortuneHistoryStore()
@AppStorage("jwtToken") private var jwtToken = ""


var body: some View {
    NavigationStack {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [
                    Color(.systemGray6),
                    Color(red: 0.96, green: 0.93, blue: 0.97)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    homeContent

                case .history:
                    HistoryView()

                case .profil:
                    ProfileView()
                }
            }

            CustomTabBar(selectedTab: $selectedTab)
        }
        .navigationBarBackButtonHidden(true)
    }
    .environmentObject(historyStore)
    .onAppear {
        historyStore.fetchHistory(token: jwtToken)
    }
    .onChange(of: selectedTab) { newValue in
        if newValue == .home {
            historyStore.fetchHistory(token: jwtToken)
        }
    }
    .onReceive(NotificationCenter.default.publisher(for: .fortuneHistoryShouldRefresh)) { _ in
        historyStore.fetchHistory(token: jwtToken)
    }
}

private var homeContent: some View {
    ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 22) {
            GreetingHeaderView()

            StatCardView(totalFortunes: historyStore.items.count)

            Text("Fal Çeşitleri")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(.label))
                .padding(.top, 4)

            VStack(spacing: 18) {
                NavigationLink(destination: CoffeeDetailView(selectedTab: $selectedTab)) {
                    FortuneCategoryCard(
                        title: "Kahve Falı",
                        subtitle: "Fincanından geleceğini oku",
                        icon: "cup.and.saucer.fill",
                        gradientColors: [
                            Color.orange,
                            Color(red: 1.0, green: 0.55, blue: 0.0)
                        ]
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(destination: TarotDetailView()) {
                    FortuneCategoryCard(
                        title: "Tarot Falı",
                        subtitle: "Kartlarla yol göster",
                        icon: "sparkles",
                        gradientColors: [Color.purple, Color.pink]
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(destination: DreamDetailView(selectedTab: $selectedTab)) {
                    FortuneCategoryCard(
                        title: "Rüya Yorumu",
                        subtitle: "Rüyalarının anlamını keşfet",
                        icon: "moon.stars.fill",
                        gradientColors: [Color.indigo, Color.purple]
                    )
                }
                .buttonStyle(.plain)
            }

            Spacer(minLength: 100)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 90)
    }
}


}

#Preview {
HomeView()
}
