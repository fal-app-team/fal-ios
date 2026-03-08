import SwiftUI

struct GenderStepView: View {
    @Binding var selected: Gender?
    var onSubmit: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {
            StepHeaderView(
                icon: "person",
                title: "Cinsiyetin",
                subtitle: "Daha kişisel yorumlar için seç",
                gradient: [.blue, .purple]
            )

            VStack(spacing: 12) {
                ForEach(Gender.allCases) { g in
                    OptionCardButton(
                        title: g.rawValue,
                        isSelected: selected == g,
                        gradient: [.purple, .pink]
                    ) {
                        selected = g
                        onSubmit?()
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}
