import SwiftUI

struct HomeView: View {
    @State private var selectedTab: TabItem = .home

    var body: some View {
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

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    GreetingHeaderView()

                    StatCardView(totalFortunes: 0)

                    Text("Fal Çeşitleri")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .padding(.top, 4)

                    VStack(spacing: 18) {
                        FortuneCategoryCard(
                            title: "Kahve Falı",
                            subtitle: "Fincanından geleceğini oku",
                            icon: "cup.and.saucer.fill",
                            gradientColors: [Color.orange, Color(red: 1.0, green: 0.55, blue: 0.0)]
                        )

                        FortuneCategoryCard(
                            title: "Tarot Falı",
                            subtitle: "Kartlarla yol göster",
                            icon: "sparkles",
                            gradientColors: [Color.purple, Color.pink]
                        )

                        FortuneCategoryCard(
                            title: "Rüya Yorumu",
                            subtitle: "Rüyalarının anlamını keşfet",
                            icon: "moon.stars.fill",
                            gradientColors: [Color.indigo, Color.purple]
                        )
                    }

                    DailyMessageCard()

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 90)
            }

            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    HomeView()
}
