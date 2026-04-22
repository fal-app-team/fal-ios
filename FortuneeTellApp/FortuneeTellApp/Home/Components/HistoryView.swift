import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyStore: FortuneHistoryStore

    var body: some View {
        ZStack {
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
                    headerSection

                    if historyStore.items.isEmpty {
                        emptyStateCard
                    } else {
                        ForEach(historyStore.items) { item in
                            FortuneHistoryCard(item: item)
                        }
                    }

                    statisticsSection

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 90)
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .center) {
            Text("Fal Geçmişi")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color(.label))

            Spacer()

            Text("\(historyStore.totalCount) Fal")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Color.purple, Color.pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
        }
    }

    private var emptyStateCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 42))
                .foregroundStyle(Color.gray.opacity(0.8))

            Text("Henüz fal geçmişin yok")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.primary)

            Text("Kahve, tarot veya rüya yorumu yaptıktan sonra geçmiş kayıtların burada görünecek.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }

    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("İstatistikler")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(.label))

            HStack {
                statItem(count: historyStore.coffeeCount, title: "Kahve Falı", color: .purple)
                Spacer()
                statItem(count: historyStore.tarotCount, title: "Tarot", color: .pink)
                Spacer()
                statItem(count: historyStore.dreamCount, title: "Rüya", color: .indigo)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 26)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(red: 0.92, green: 0.86, blue: 0.94))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private func statItem(count: Int, title: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(color)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}

struct FortuneHistoryCard: View {
    let item: FortuneHistoryItem
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                iconBox

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.type.rawValue)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(.label))

                    Text(formattedDate(item.date))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            Text(previewText)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(.label).opacity(0.88))
                .lineSpacing(4)
                .lineLimit(3)

            Button {
                showDetail = true
            } label: {
                Text("Detayları Gör")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(.label).opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.07), radius: 14, x: 0, y: 8)
        .sheet(isPresented: $showDetail) {
            FortuneDetailView(item: item)
        }
    }

    private var iconBox: some View {
        LinearGradient(
            colors: item.type.gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            Image(systemName: item.type.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private var previewText: String {
        if let interpretation = item.interpretation, !interpretation.isEmpty {
            return interpretation
        } else {
            return item.status
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        return formatter.string(from: date)
    }
}
