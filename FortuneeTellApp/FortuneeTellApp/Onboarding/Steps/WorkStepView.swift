import SwiftUI

struct WorkStepView: View {
    @Binding var selected: WorkStatus?

    var body: some View {
        VStack(spacing: 18) {

            StepHeaderView(
                icon: "briefcase",
                title: "İş Durumun",
                subtitle: "Kariyer falında kullanılacak",
                gradient: [.orange, .red]
            )

            VStack(spacing: 12) {
                ForEach(WorkStatus.allCases) { w in
                    OptionCardButton(
                        title: w.rawValue,
                        isSelected: selected == w,
                        gradient: [.orange, .red]
                    ) {
                        selected = w
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}
