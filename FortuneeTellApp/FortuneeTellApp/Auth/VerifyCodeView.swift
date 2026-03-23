import SwiftUI

struct VerifyCodeView: View {
    let email: String
    @State private var code = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Arka plan gradient
                LinearGradient(
                    colors: [
                        Color(red: 42/255, green: 10/255, blue: 99/255),
                        Color(red: 68/255, green: 20/255, blue: 140/255),
                        Color(red: 96/255, green: 36/255, blue: 170/255)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Yıldız efekti 
                StarsOverlay()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Doğrulama Kodunu Gir")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Mailinize gönderilen 6 haneli kodu girin")
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    TextField("", text: $code)
                        .placeholder(when: code.isEmpty) {
                            Text("Kod")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(14)
                        .foregroundColor(.white)
                    
                    Button(action: verifyCode) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple.opacity(0.7))
                                .cornerRadius(14)
                        } else {
                            Text("Doğrula")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.purple, Color.pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(14)
                                .shadow(color: .pink.opacity(0.3), radius: 8, x: 0, y: 4)
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(isLoading || code.count != 6)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
            }
            // iOS16+ navigationDestination
            .navigationDestination(isPresented: $navigateToHome) {
                OnboardingFlowView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
    }
    
    private func verifyCode() {
        isLoading = true
        let request = VerifyCodeRequest(email: email, code: code)
        AuthService.shared.verifyCode(request: request) { result in
            isLoading = false
            switch result {
            case .success(_):
                navigateToHome = true
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
