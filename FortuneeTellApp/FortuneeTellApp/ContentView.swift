import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct ContentView: View {
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if !isLoggedIn {
                loginScreen
            } else if !hasCompletedOnboarding {
                OnboardingFlowView()
            } else {
                HomeView()
            }
        }
        .onAppear {
            isLoggedIn = Auth.auth().currentUser != nil
        }
    }
    
    private var loginScreen: some View {
        NavigationStack {
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        Spacer()
                            .frame(height: 40)
                        
                        VStack(spacing: 10) {
                            Text("Falcınız")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundColor(.white)
                            
                            Text("Kaderine Işık Tut")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white.opacity(0.96))
                            
                            Text("Geleceğini keşfet.")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white.opacity(0.75))
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        
                        Spacer()
                            .frame(height: 22)
                        
                        HStack(spacing: 10) {
                            FeatureChip(icon: "sparkles", text: "Günlük Fal")
                            FeatureChip(icon: "moon.stars.fill", text: "Rüya Yorumu")
                            FeatureChip(icon: "wand.and.stars", text: "Tarot")
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer()
                            .frame(height: 28)
                        
                        Image("falHero")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.22), lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.28), radius: 18, x: 0, y: 10)
                            .shadow(color: Color.pink.opacity(0.18), radius: 16, x: 0, y: 0)
                        
                        Spacer()
                            .frame(height: 26)
                        
                        VStack(spacing: 18) {
                            
                            VStack(spacing: 6) {
                                Text("Hoş Geldin")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Mistik yolculuğuna başla")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.72))
                            }
                            
                            Button(action: {
                                signInWithGoogle()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "globe")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Google ile Giriş Yap")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.white.opacity(0.10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                        )
                                )
                            }
                            
                            HStack(spacing: 12) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.13))
                                    .frame(height: 1)
                                
                                Text("ya da")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.65))
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.13))
                                    .frame(height: 1)
                            }
                            .padding(.top, 2)
                            
                            NavigationLink {
                                EmailLoginView()
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "envelope")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("E-mail ile Devam Et")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 180/255, green: 60/255, blue: 1),
                                            Color(red: 1, green: 40/255, blue: 170/255)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: .pink.opacity(0.30), radius: 14, x: 0, y: 8)
                            }
                            
                            VStack(spacing: 10) {
                                HStack(spacing: 4) {
                                    Text("Hesabın yok mu?")
                                        .foregroundColor(.white.opacity(0.68))
                                    
                                    NavigationLink("Kayıt Ol") {
                                        RegisterView()
                                    }
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                }
                                
                                HStack(spacing: 4) {
                                    Text("Zaten hesabın var mı?")
                                        .foregroundColor(.white.opacity(0.68))
                                    
                                    NavigationLink("Giriş Yap") {
                                        LoginView()
                                    }
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                }
                            }
                            .font(.system(size: 15))
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 26)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white.opacity(0.14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 22)
                        
                        Spacer()
                            .frame(height: 30)
                    }
                }
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("clientID bulunamadı")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("RootViewController bulunamadı")
            return
        }
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google giriş hatası: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Google kullanıcı bilgisi alınamadı")
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Google giriş hatası: \(error.localizedDescription)")
                    return
                }
                
                print("Google ile giriş başarılı: \(authResult?.user.email ?? "mail yok")")
                
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
            }
        }
    }
}

struct FeatureChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text)
                .lineLimit(1)
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(.white.opacity(0.88))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.10))
        )
    }
}

struct StarsOverlay: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<30, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.15...0.8)))
                        .frame(
                            width: CGFloat.random(in: 2...4),
                            height: CGFloat.random(in: 2...4)
                        )
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                }
            }
        }
    }
}

// Geçici sayfalar
struct EmailLoginView: View {
    var body: some View {
        Text("E-mail ile Devam Et Sayfası")
            .navigationTitle("E-mail")
    }
}

struct RegisterView: View {
    var body: some View {
        Text("Kayıt Ol Sayfası")
            .navigationTitle("Kayıt Ol")
    }
}

struct LoginView: View {
    var body: some View {
        Text("Giriş Yap Sayfası")
            .navigationTitle("Giriş Yap")
    }
}

#Preview {
    ContentView()
}
