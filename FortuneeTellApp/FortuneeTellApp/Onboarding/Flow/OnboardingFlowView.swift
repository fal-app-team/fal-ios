import SwiftUI

struct OnboardingFlowView: View {
    @StateObject private var vm = OnboardingViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    func goNext() {
        if vm.step < 5 && vm.canGoNext(step: vm.step) {
            withAnimation {
                vm.step += 1
            }
        } else if vm.step == 5 {
            hasCompletedOnboarding = true
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple.opacity(0.10), Color.pink.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {

                HStack {
                    Button {
                        if vm.step > 0 {
                            withAnimation {
                                vm.step -= 1
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .opacity(vm.step == 0 ? 0 : 1)
                    .disabled(vm.step == 0)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                ZStack {
                    switch vm.step {
                    case 0:
                        NameStepView(name: $vm.name) {
                            goNext()
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))

                    case 1:
                        BirthDateStepView(birthDate: $vm.birthDate)
                            .transition(.move(edge: .trailing).combined(with: .opacity))

                    case 2:
                        GenderStepView(selected: $vm.gender)
                            .transition(.move(edge: .trailing).combined(with: .opacity))

                    case 3:
                        RelationshipStepView(selected: $vm.relationship)
                            .transition(.move(edge: .trailing).combined(with: .opacity))

                    case 4:
                        WorkStepView(selected: $vm.work)
                            .transition(.move(edge: .trailing).combined(with: .opacity))

                    case 5:
                        WelcomeStepView()
                            .transition(.move(edge: .trailing).combined(with: .opacity))

                    default:
                        EmptyView()
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: vm.step)

                PageDotsView(current: vm.step, total: 6)

                GradientButton(
                    title: vm.step == 5 ? "Falına Başla" : "Devam",
                    isEnabled: vm.canGoNext(step: vm.step)
                ) {
                    if vm.step < 5 {
                        withAnimation {
                            vm.step += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
    }
}
