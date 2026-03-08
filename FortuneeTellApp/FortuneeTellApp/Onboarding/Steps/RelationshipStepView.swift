import SwiftUI

struct RelationshipStepView: View {
    @Binding var selected: RelationshipStatus?

    var body: some View {
        VStack(spacing: 18) {
            StepHeaderView(
                icon: "heart",
                title: "İlişki Durumun",
                subtitle: "Aşk falında kullanılacak",
                gradient: [.pink, .red]
            )

            VStack(spacing: 12) {
                ForEach(RelationshipStatus.allCases) { r in
                    OptionCardButton(
                        title: r.rawValue,
                        isSelected: selected == r,
                        gradient: [.pink, .red]
                    ) {
                        selected = r
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}
