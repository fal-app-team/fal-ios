import SwiftUI

struct BirthDateStepView: View {
    @Binding var birthDate: Date?
    @State private var showDatePicker = false
    @State private var tempDate = Date()

    var body: some View {
        VStack(spacing: 18) {

            StepHeaderView(
                icon: "calendar",
                title: "Doğum Tarihin",
                subtitle: "Falında kullanmak için doğum tarihini gir",
                gradient: [.purple, .pink]
            )

            InputCardView(label: "Doğum Tarihi") {
                Button {
                    if let birthDate {
                        tempDate = birthDate
                    } else {
                        tempDate = Date()
                    }
                    showDatePicker = true
                } label: {
                    HStack {
                        Text(birthDate == nil ? "gg.aa.yyyy" : formattedDate)
                            .foregroundStyle(birthDate == nil ? .secondary : .primary)

                        Spacer()

                        Image(systemName: "calendar")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }

            Spacer()
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 16) {
                Text("Doğum Tarihini Seç")
                    .font(.headline)
                    .padding(.top, 20)

                DatePicker(
                    "Doğum Tarihi",
                    selection: $tempDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                Button {
                    birthDate = tempDate
                    showDatePicker = false
                } label: {
                    HStack {
                        Spacer()
                        Text("Seç")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var formattedDate: String {
        guard let birthDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: birthDate)
    }
}

#Preview {
    BirthDateStepView(birthDate: .constant(nil))
}
