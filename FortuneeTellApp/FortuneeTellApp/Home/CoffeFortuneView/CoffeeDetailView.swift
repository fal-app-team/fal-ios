import SwiftUI
import UIKit

struct CoffeeDetailView: View {
    @EnvironmentObject var historyStore: FortuneHistoryStore
    @Binding var selectedTab: TabItem
    
    @State private var selectedImages: [UIImage?] = [nil, nil, nil]
    @State private var selectedIndex: Int? = nil
    
    @State private var showPhotoLibrary = false
    @State private var showCamera = false
    @State private var showCameraUnavailableAlert = false
    @State private var showMissingPhotosAlert = false
    @State private var isLoading = false
    
    private let photoTitles = ["Fincan İçi", "Tabak", "Yan Açı"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemGray6),
                    Color(red: 0.96, green: 0.93, blue: 0.97)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 24) {
                        
                        headerSection
                        
                        VStack(alignment: .leading, spacing: 22) {
                            ForEach(0..<3, id: \.self) { index in
                                photoSection(index: index)
                            }
                        }
                        
                        if hasMissingImages {
                            HStack(spacing: 10) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(.red)
                                
                                Text("Devam etmek için 3 fotoğrafın da yüklenmesi gerekiyor.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        sendButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color(red: 0.96, green: 0.93, blue: 0.96))
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(
                sourceType: .photoLibrary,
                selectedImage: bindingForSelectedImage()
            )
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(
                sourceType: .camera,
                selectedImage: bindingForSelectedImage()
            )
        }
        .alert("Kamera kullanılamıyor", isPresented: $showCameraUnavailableAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Simulator'da kamera çalışmaz. Gerçek cihazda deneyebilirsin.")
        }
        .alert("Eksik fotoğraf var", isPresented: $showMissingPhotosAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Lütfen Fincan İçi, Tabak ve Yan Açı fotoğraflarının üçünü de yükle.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Kahve Falı")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.black.opacity(0.9))
            
            Text("3 farklı açıdan fincan fotoğrafı yükle")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }
    
    private var sendButton: some View {
        Button {
            submitFortune()
        } label: {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                
                Text(isLoading ? "Yorumlanıyor..." : "Falı Gönder / Yorumla")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                LinearGradient(
                    colors: [Color.purple, Color.pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
            .opacity(allImagesSelected ? 1.0 : 0.65)
        }
        .disabled(isLoading)
    }
    
    private var allImagesSelected: Bool {
        selectedImages.allSatisfy { $0 != nil }
    }
    
    private var hasMissingImages: Bool {
        selectedImages.contains { $0 == nil }
    }
    
    @ViewBuilder
    private func photoSection(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 8) {
                Text(photoTitles[index])
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
                
                if selectedImages[index] == nil {
                    Text("Gerekli")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.9))
                        .clipShape(Capsule())
                }
            }
            
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.92))
                    .frame(height: 220)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                
                if let image = selectedImages[index] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    Button {
                        selectedImages[index] = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white, .black.opacity(0.35))
                            .padding(10)
                    }
                    .buttonStyle(.plain)
                } else {
                    Button {
                        selectedIndex = index
                        showPhotoLibrary = true
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.system(size: 42, weight: .medium))
                                .foregroundStyle(Color.gray.opacity(0.75))
                            
                            Text("Fotoğraf Yükle")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color.gray.opacity(0.82))
                            
                            Text("Galeriden seçmek için dokun")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.gray.opacity(0.65))
                        }
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                }
            }
            
            HStack(spacing: 12) {
                Button {
                    selectedIndex = index
                    showPhotoLibrary = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle")
                        Text("Galeriden Seç")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(.label))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                
                Button {
                    selectedIndex = index
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        showCamera = true
                    } else {
                        showCameraUnavailableAlert = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "camera")
                        Text("Fotoğraf Çek")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(.label))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func bindingForSelectedImage() -> Binding<UIImage?> {
        Binding(
            get: {
                guard let selectedIndex else { return nil }
                return selectedImages[selectedIndex]
            },
            set: { newValue in
                guard let selectedIndex else { return }
                selectedImages[selectedIndex] = newValue
            }
        )
    }
    
    private func submitFortune() {
        guard allImagesSelected else {
            showMissingPhotosAlert = true
            return
        }
        
        let images = selectedImages.compactMap { $0 }
        guard images.count == 3 else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            historyStore.addCoffeeFortune(images: images)
            selectedImages = [nil, nil, nil]
            isLoading = false
            selectedTab = .history
        }
    }
}

#Preview {
    CoffeeDetailView(selectedTab: .constant(.home))
        .environmentObject(FortuneHistoryStore())
}
