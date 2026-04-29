import SwiftUI

// --- 1. MODELLER VE ENUMLAR ---

enum HistoryDateFilter: String, CaseIterable {
    case all = "Tümü"
    case today = "Bugün"
    case week = "Bu Hafta"
    case month = "Bu Ay"
}

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let count: Int
}

extension FortuneType: Identifiable {
    public var id: Self { self }
}

// --- 2. ANA GEÇMİŞ GÖRÜNÜMÜ ---

struct HistoryView: View {
    @EnvironmentObject var historyStore: FortuneHistoryStore
    @AppStorage("jwtToken") private var jwtToken = ""
    
    // Uygulama "Bu Hafta" seçili olarak başlar
    @State private var selectedFilter: HistoryDateFilter = .week
    @State private var selectedTypeForDetail: FortuneType? = nil

    private var filteredItems: [FortuneHistoryItem] {
        let calendar = Calendar.current
        let now = Date()
        switch selectedFilter {
        case .all: return historyStore.items
        case .today: return historyStore.items.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case .week: return historyStore.items.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear) }
        case .month: return historyStore.items.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
        }
    }

    // --- TÜRKÇE VE DİNAMİK GRAFİK VERİSİ ---
    private var chartStats: [ChartData] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "tr_TR") // Türkçe yerelleştirme zorunlu kılındı
        let now = Date()
        
        switch selectedFilter {
        case .today:
            // Günlük: 08-12, 12-16 gibi aralık bazlı gösterim
            let intervals = [
                ("00-08", 0, 8), ("08-12", 8, 12), ("12-16", 12, 16),
                ("16-20", 16, 20), ("20-00", 20, 24)
            ]
            return intervals.map { label, start, end in
                let count = historyStore.items.filter { item in
                    let hour = calendar.component(.hour, from: item.date)
                    return calendar.isDate(item.date, inSameDayAs: now) && hour >= start && hour < end
                }.count
                return ChartData(label: label, count: count)
            }
            
        case .week:
            // Haftalık: Pzt, Sal, Çar...
            let weekdays = [("Pzt", 2), ("Sal", 3), ("Çar", 4), ("Per", 5), ("Cum", 6), ("Cmt", 7), ("Paz", 1)]
            return weekdays.map { label, num in
                let count = historyStore.items.filter {
                    calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear) &&
                    calendar.component(.weekday, from: $0.date) == num
                }.count
                return ChartData(label: label, count: count)
            }
            
        case .month:
            // Aylık: 1. Hafta, 2. Hafta...
            return (0..<4).map { i in
                let count = historyStore.items.filter {
                    calendar.isDate($0.date, equalTo: now, toGranularity: .month) &&
                    (calendar.component(.day, from: $0.date)-1)/7 == i
                }.count
                return ChartData(label: "\(i+1). Hafta", count: count)
            }
            
        case .all:
            // Tümü: Son 6 ayın TÜRKÇE isimleri
            let monthSymbols = calendar.shortMonthSymbols // "Oca", "Şub", "Mar"...
            return (0..<6).reversed().map { i in
                let date = calendar.date(byAdding: .month, value: -i, to: now)!
                let monthIndex = calendar.component(.month, from: date) - 1
                let count = historyStore.items.filter { calendar.isDate($0.date, equalTo: date, toGranularity: .month) }.count
                return ChartData(label: monthSymbols[monthIndex], count: count)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemGray6), Color(red: 0.96, green: 0.93, blue: 0.97)],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        headerSection
                        filterSection
                        
                        // Dinamik Analiz Kartı
                        dynamicChartSection
                        
                        if historyStore.isLoading {
                            ProgressView("Yükleniyor...").frame(maxWidth: .infinity).padding()
                        } else if filteredItems.isEmpty {
                            emptyStateCard
                        } else {
                            fortuneSection(title: " Kahve Falların", type: .coffee)
                            fortuneSection(title: " Tarot Açılımların", type: .tarot)
                            fortuneSection(title: "Rüya Yorumların", type: .dream)
                        }
                        
                        statisticsSection
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .sheet(item: $selectedTypeForDetail) { type in
                AllFortunesListView(type: type, items: filteredItems.filter { $0.type == type })
            }
        }
        .onAppear {
            historyStore.fetchHistory(token: jwtToken)
        }
    }

    // --- DİNAMİK GRAFİK TASARIMI ---
    private var dynamicChartSection: some View {
        let stats = chartStats
        let maxCount = stats.map { $0.count }.max() ?? 1
        let chartHeight: CGFloat = 100

        return VStack(alignment: .leading, spacing: 15) {
            Text(selectedFilter == .today ? "Günlük Analiz" :
                 selectedFilter == .week ? "Haftalık Analiz" :
                 selectedFilter == .month ? "Aylık Analiz" : "Genel Analiz")
                .font(.system(size: 18, weight: .bold))
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(stats) { stat in
                    VStack(spacing: 8) {
                        if stat.count > 0 {
                            Text("\(stat.count)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom))
                            .frame(height: maxCount > 0 ? (CGFloat(stat.count) / CGFloat(maxCount)) * chartHeight : 5)
                            .animation(.spring(), value: selectedFilter)
                        
                        Text(stat.label)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }

    private var headerSection: some View {
        HStack {
            Text("Fal Geçmişi").font(.system(size: 30, weight: .bold))
            Spacer()
            Text("\(filteredItems.count) Fal")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 15).padding(.vertical, 8)
                .background(Color.pink)
                .clipShape(Capsule())
        }
    }

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(HistoryDateFilter.allCases, id: \.self) { filter in
                    Button { withAnimation { selectedFilter = filter } } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedFilter == filter ? .white : .purple)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(selectedFilter == filter ? Color.purple : Color.white)
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                }
            }
        }
    }

    private func fortuneSection(title: String, type: FortuneType) -> some View {
        let allItems = filteredItems.filter { $0.type == type }
        return VStack(alignment: .leading, spacing: 15) {
            if !allItems.isEmpty {
                HStack {
                    Text(title).font(.system(size: 20, weight: .bold))
                    Spacer()
                    Button("Hepsini Gör") { selectedTypeForDetail = type }
                        .font(.system(size: 14, weight: .bold)).foregroundStyle(.purple)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(allItems.prefix(5)) { item in
                            FortuneHistoryCard(item: item).frame(width: 280)
                        }
                        if allItems.count > 5 {
                            Button { selectedTypeForDetail = type } label: {
                                moreCard(count: allItems.count - 5)
                            }
                        }
                    }
                }
            }
        }
    }

    private func moreCard(count: Int) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "plus.circle.fill").font(.title).foregroundStyle(.purple)
            Text("\(count) Fal Daha").font(.subheadline).bold()
        }
        .frame(width: 140, height: 210).background(Color.purple.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.purple.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [5])))
    }

    private var statisticsSection: some View {
        HStack(spacing: 15) {
            statItem(count: filteredItems.filter { $0.type == .coffee }.count, title: "Kahve", color: .orange)
            statItem(count: filteredItems.filter { $0.type == .tarot }.count, title: "Tarot", color: .purple)
            statItem(count: filteredItems.filter { $0.type == .dream }.count, title: "Rüya", color: .blue)
        }
        .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func statItem(count: Int, title: String, color: Color) -> some View {
        VStack {
            Text("\(count)").font(.title3).bold().foregroundStyle(color)
            Text(title).font(.caption).bold().foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity)
    }

    private var emptyStateCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath").font(.system(size: 40)).foregroundStyle(.gray.opacity(0.5))
            Text("Kayıt bulunamadı").font(.headline)
        }.frame(maxWidth: .infinity).padding(.vertical, 40)
    }
}

// --- 3. KART GÖRÜNÜMÜ (MARKDOWN DESTEKLİ) ---

struct FortuneHistoryCard: View {
    let item: FortuneHistoryItem
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                LinearGradient(colors: item.type.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: 48, height: 48).clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay { Image(systemName: item.type.icon).font(.system(size: 20, weight: .bold)).foregroundStyle(.white) }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.type.displayName).font(.system(size: 18, weight: .bold))
                    Text(formattedDate(item.date)).font(.system(size: 13, weight: .medium)).foregroundStyle(.secondary)
                }
                Spacer()
            }

            Text(LocalizedStringKey(item.aiResponse ?? "Yorum hazırlanıyor..."))
                .font(.system(size: 15, weight: .medium)).foregroundStyle(.secondary)
                .lineLimit(3).frame(height: 55, alignment: .top)

            Button { showDetail = true } label: {
                Text("Detayları Gör").font(.system(size: 15, weight: .bold)).foregroundStyle(.purple)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Color.purple.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24)).shadow(color: .black.opacity(0.04), radius: 10, y: 5)
        .sheet(isPresented: $showDetail) { FortuneDetailView(item: item) }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        return formatter.string(from: date)
    }
}

// --- 4. HEPSİNİ GÖR LİSTESİ (SAYFALAMA İLE) ---

struct AllFortunesListView: View {
    let type: FortuneType
    let items: [FortuneHistoryItem]
    @State private var currentPage = 1
    private let itemsPerPage = 10
    
    private var totalPages: Int {
        let count = items.count
        return count > 0 ? Int(ceil(Double(count) / Double(itemsPerPage))) : 1
    }
    
    private var pagedItems: [FortuneHistoryItem] {
        let startIndex = (currentPage - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, items.count)
        if startIndex >= items.count { return [] }
        return Array(items[startIndex..<endIndex])
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(pagedItems) { item in FortuneHistoryCard(item: item) }
                    }.padding(20)
                }
                paginationControl
            }
            .navigationTitle("\(type.displayName) Geçmişi")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
        }
    }
    
    private var paginationControl: some View {
        VStack(spacing: 12) {
            Divider()
            HStack(spacing: 15) {
                Button { if currentPage > 1 { currentPage -= 1 } } label: {
                    Image(systemName: "chevron.left").fontWeight(.bold).padding(10)
                        .background(currentPage > 1 ? Color.purple.opacity(0.1) : Color.clear).clipShape(Circle())
                }.disabled(currentPage == 1)

                HStack(spacing: 8) {
                    ForEach(1...max(1, totalPages), id: \.self) { number in
                        if shouldShowPage(number) {
                            pageNumberButton(number)
                        } else if number == 2 || (number == totalPages - 1 && totalPages > 5) {
                            Text("...").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }

                Button { if currentPage < totalPages { currentPage += 1 } } label: {
                    Image(systemName: "chevron.right").fontWeight(.bold).padding(10)
                        .background(currentPage < totalPages ? Color.purple.opacity(0.1) : Color.clear).clipShape(Circle())
                }.disabled(currentPage == totalPages)
            }.padding(.bottom, 20).padding(.top, 5)
        }.background(Color.white)
    }

    private func pageNumberButton(_ number: Int) -> some View {
        Button { currentPage = number } label: {
            Text("\(number)").font(.system(size: 14, weight: .bold)).frame(width: 35, height: 35)
                .background(currentPage == number ? Color.purple : Color.clear)
                .foregroundStyle(currentPage == number ? .white : .purple)
                .clipShape(Circle()).overlay(Circle().stroke(Color.purple.opacity(0.2), lineWidth: currentPage == number ? 0 : 1))
        }
    }
    
    private func shouldShowPage(_ number: Int) -> Bool {
        if totalPages <= 5 { return true }
        if number == 1 || number == totalPages { return true }
        if abs(number - currentPage) <= 1 { return true }
        return false
    }
}
