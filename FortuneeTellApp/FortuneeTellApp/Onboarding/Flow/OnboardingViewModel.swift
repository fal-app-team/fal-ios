import SwiftUI

enum Gender: String, CaseIterable, Identifiable {
    case woman = "Kadın"
    case man = "Erkek"
    case other = "Diğer"
    case notSay = "Belirtmek istemiyorum"
    var id: String { rawValue }
}

enum RelationshipStatus: String, CaseIterable, Identifiable {
    case single = "Bekar"
    case married = "Evli"
    case inRelation = "İlişkisi var"
    case complicated = "Karmaşık"
    var id: String { rawValue }
}

enum WorkStatus: String, CaseIterable, Identifiable {
    case working = "Çalışıyor"
    case looking = "İş Arıyor"
    case student = "Öğrenci"
    case retired = "Emekli"
    case entrepreneur = "Kendi işini yapıyor"
    var id: String { rawValue }
}

final class OnboardingViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var gender: Gender? = nil
    @Published var relationship: RelationshipStatus? = nil
    @Published var work: WorkStatus? = nil
    @Published var birthDate: Date? = nil
    @Published var step: Int = 0

    func canGoNext(step: Int) -> Bool {
        switch step {
        case 0: return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 1: return birthDate != nil
        case 2: return gender != nil
        case 3: return relationship != nil
        case 4: return work != nil
        default: return false
        }
    }
}
