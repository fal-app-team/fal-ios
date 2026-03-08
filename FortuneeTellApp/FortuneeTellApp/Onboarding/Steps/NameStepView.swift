import SwiftUI

struct NameStepView: View {
    @Binding var name: String
    @FocusState private var isFocused: Bool
    var onSubmit: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {

            StepHeaderView(
                icon: "person",
                title: "Adın",
                subtitle: "Seni nasıl çağıralım?",
                gradient: [.blue, .purple]
            )

            VStack(alignment: .leading, spacing: 8) {

                Text("İsim")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {

                    Image(systemName: "person.fill")
                        .foregroundStyle(.secondary)

                    TextField("Adını gir", text: $name)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            onSubmit?()
                        }

                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(16)
            .background(Color.white.opacity(0.60))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
            .padding(.horizontal, 20)

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFocused = true
            }
        }
    }
}
