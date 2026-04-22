import SwiftUI

struct DreamDetailView: View {
    @EnvironmentObject var historyStore: FortuneHistoryStore
    @Binding var selectedTab: TabItem

    @State private var dreamText: String = ""
    @StateObject private var viewModel = DreamViewModel()
    @State private var selectedSymbols: Set<String> = []

    private let symbols = ["su", "kuş", "araba", "ev", "köpek", "kedi", "yılan", "balık"]

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.93, blue: 0.96)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    headerSection
                    inputCard
                    interpretButton
                    resultSection
                    symbolsCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Rüya Yorumu")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Rüya Yorumu")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))

            Text("Rüyanı anlat, yorumunu al")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.top, 8)
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rüyanı Anlat")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.22, green: 0.27, blue: 0.36))

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.55))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                    )
                    .frame(height: 170)

                if dreamText.isEmpty {
                    Text("Örnek: Gökyüzünde uçuyordum, sonra büyük bir denize düştüm...")
                        .font(.system(size: 16))
                        .foregroundColor(Color.gray.opacity(0.9))
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                }

                TextEditor(text: $dreamText)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(height: 170)
            }

            Text("En az 10 karakter yazmalısın")
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
        .padding(20)
        .background(Color.white.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }

    private var interpretButton: some View {
        Button {
            Task {
                await interpretAndSaveDream()
            }
        } label: {
            HStack(spacing: 10) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                }

                Text(viewModel.isLoading ? "Yorumlanıyor..." : "Rüyayı Yorumla")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.52))
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .background(Color(red: 0.82, green: 0.84, blue: 0.88))
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
        .disabled(dreamText.count < 10 || viewModel.isLoading)
    }

    private var symbolsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.purple)

                Text("Rüya Sembolleri")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))
            }

            FlowLayout(spacing: 10) {
                ForEach(symbols, id: \.self) { symbol in
                    Button {
                        if selectedSymbols.contains(symbol) {
                            selectedSymbols.remove(symbol)
                        } else {
                            selectedSymbols.insert(symbol)
                        }
                    } label: {
                        Text(symbol)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(
                                selectedSymbols.contains(symbol)
                                ? .white
                                : Color(red: 0.24, green: 0.28, blue: 0.38)
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                selectedSymbols.contains(symbol)
                                ? Color.purple
                                : Color.white.opacity(0.95)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .background(Color(red: 0.87, green: 0.86, blue: 0.98))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 8)
    }

    private var resultSection: some View {
        VStack(spacing: 12) {
            if viewModel.isLoading {
                ProgressView("Rüyan yorumlanıyor...")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }

            if !viewModel.interpretationResult.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Yorum")
                        .font(.title3.bold())

                    Text(viewModel.interpretationResult)
                        .foregroundColor(.primary)

                    if !viewModel.themes.isEmpty {
                        Text("Temalar: \(viewModel.themes.joined(separator: ", "))")
                            .foregroundColor(.gray)
                    }

                    if !viewModel.suggestion.isEmpty {
                        Text("Öneri: \(viewModel.suggestion)")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
    }

    @MainActor
    private func interpretAndSaveDream() async {
        await viewModel.interpretDream(
            dreamText: dreamText,
            symbols: Array(selectedSymbols)
        )

        guard !viewModel.interpretationResult.isEmpty else { return }

        historyStore.addDreamFortune(
            interpretation: viewModel.interpretationResult,
            themes: viewModel.themes,
            suggestion: viewModel.suggestion
        )

        selectedTab = .history
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }

            rowHeight = max(rowHeight, size.height)
            currentX += size.width + spacing
        }

        return CGSize(width: maxWidth, height: currentY + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(width: size.width, height: size.height)
            )

            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        DreamDetailView(selectedTab: .constant(.home))
            .environmentObject(FortuneHistoryStore())
    }
}
