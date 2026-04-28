import SwiftUI

enum HistoryDateFilter: String, CaseIterable {
    case all = "Tümü"
    case today = "Bugün"
    case week = "Bu Hafta"
    case month = "Bu Ay"
}

struct HistoryView: View {
    @EnvironmentObject var historyStore: FortuneHistoryStore
    @AppStorage("jwtToken") private var jwtToken = ""

    @State private var selectedFilter: HistoryDateFilter = .all

    private var filteredItems: [FortuneHistoryItem] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedFilter {
        case .all:
            return historyStore.items

        case .today:
            return historyStore.items.filter {
                calendar.isDate($0.date, inSameDayAs: now)
            }

        case .week:
            return historyStore.items.filter {
                calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear)
            }

        case .month:
            return historyStore.items.filter {
                calendar.isDate($0.date, equalTo: now, toGranularity: .month)
            }
        }
    }

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
                    filterSection
                    weeklyChartSection

                    if historyStore.isLoading {
                        ProgressView("Yükleniyor...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if filteredItems.isEmpty {
                        emptyStateCard
                    } else {
                        ForEach(filteredItems) { item in
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
        .onAppear {
            historyStore.fetchHistory(token: jwtToken)
        }
    }

    private var headerSection: some View {
        HStack {
            Text("Fal Geçmişi")
                .font(.system(size: 30, weight: .bold))

            Spacer()

            Text("\(filteredItems.count) Fal")
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

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(HistoryDateFilter.allCases, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(selectedFilter == filter ? .white : .purple)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                selectedFilter == filter
                                ? Color.purple
                                : Color.white.opacity(0.95)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var weeklyChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Haftalık Fal Grafiği")
                .font(.system(size: 22, weight: .bold))

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(weeklyStats, id: \.day) { stat in
                    VStack(spacing: 8) {
                        Text("\(stat.count)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.purple)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(height: CGFloat(max(stat.count, 1)) * 18)

                        Text(stat.day)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 150)
        }
        .padding(20)
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var weeklyStats: [(day: String, count: Int)] {
        let calendar = Calendar.current
        let now = Date()

        let weekdays = [
            ("Pzt", 2),
            ("Sal", 3),
            ("Çar", 4),
            ("Per", 5),
            ("Cum", 6),
            ("Cmt", 7),
            ("Paz", 1)
        ]

        let weekItems = historyStore.items.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear)
        }

        return weekdays.map { dayName, weekdayNumber in
            let count = weekItems.filter {
                calendar.component(.weekday, from: $0.date) == weekdayNumber
            }.count

            return (dayName, count)
        }
    }

    private var emptyStateCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 42))
                .foregroundStyle(Color.gray.opacity(0.8))

            Text("Bu filtrede fal bulunamadı")
                .font(.system(size: 22, weight: .bold))

            Text("Seçtiğin tarih aralığında geçmiş fal kaydı yok.")
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

            HStack {
                statItem(count: filteredItems.filter { $0.type == .coffee }.count, title: "Kahve Falı", color: .purple)
                Spacer()
                statItem(count: filteredItems.filter { $0.type == .tarot }.count, title: "Tarot", color: .pink)
                Spacer()
                statItem(count: filteredItems.filter { $0.type == .dream }.count, title: "Rüya", color: .indigo)
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

// --- KART GÖRÜNÜMÜ ---

struct FortuneHistoryCard: View {
    let item: FortuneHistoryItem
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                iconBox

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.type.displayName) // Yeni eklediğimiz displayName'i kullanıyoruz
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
        }    }

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
        return item.aiResponse ?? "Yorum hazırlanıyor..."
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        return formatter.string(from: date)
    }
}
