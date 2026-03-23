import SwiftUI


struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToVerify = false
    
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
                Text("Email ile Devam Et")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    // Name
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("", text: $name)
                            .placeholder(when: name.isEmpty) {
                                Text("Ad Soyad")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .foregroundColor(.white)
                            .autocapitalization(.words)
                    }
                    .padding()
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(14)
                    
                    // Email
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
                    
                    // Password
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
                
                // Register Button
                Button(action: registerUser) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.purple.opacity(0.7))
                                            .cornerRadius(14)
                                    } else {
                                        Text("Hesap Oluştur")
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
                                .disabled(isLoading || name.isEmpty || email.isEmpty || password.isEmpty)
                                
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 40)
                            // iOS16+ NavigationDestination
                            .navigationDestination(isPresented: $navigateToVerify) {
                                VerifyCodeView(email: email)
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
                        }
                    }
    
    private func registerUser() {
        isLoading = true
        let request = RegisterRequest(name: name, email: email, password: password)
        AuthService.shared.register(request: request) { result in
            isLoading = false
            switch result {
            case .success(let response):
                print(response.message)
                navigateToVerify = true
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
