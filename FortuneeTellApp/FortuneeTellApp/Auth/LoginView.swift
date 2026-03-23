import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false
    
    var body: some View {
        ZStack {
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
            
            StarsOverlay()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Giriş Yap")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("", text: $email)
                            .placeholder(when: email.isEmpty) {
                                Text("E-mail")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(14)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.7))
                        SecureField("", text: $password)
                            .placeholder(when: password.isEmpty) {
                                Text("Şifre")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(14)
                }
                
                Button(action: loginUser) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.purple.opacity(0.7))
                                            .cornerRadius(14)
                                    } else {
                                        Text("Giriş Yap")
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
                                .disabled(isLoading || email.isEmpty || password.isEmpty)
                                
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 40)
                            // iOS16+ NavigationDestination
                            .navigationDestination(isPresented: $navigateToHome) {
                                OnboardingFlowView()
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
                        }
                    }
    
    private func loginUser() {
        isLoading = true
        let request = LoginRequest(email: email, password: password)
        AuthService.shared.login(request: request) { result in
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
