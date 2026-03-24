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
// MARK: - Gender Mapping
extension Gender {
    var backendValue: String {
        switch self {
        case .woman:
            return "FEMALE"
        case .man:
            return "MALE"
        case .other:
            return "OTHER"
        case .notSay:
            return "OTHER"
        }
    }
}

// MARK: - Relationship Mapping
extension RelationshipStatus {
    var backendValue: String {
        switch self {
        case .single:
            return "SINGLE"
        case .married:
            return "MARRIED"
        case .inRelation:
            return "IN_RELATIONSHIP"
        case .complicated:
            return "COMPLICATED"
        }
    }
}

// MARK: - Work Mapping
extension WorkStatus {
    var backendValue: String {
        switch self {
        case .working:
            return "EMPLOYED"
        case .looking:
            return "UNEMPLOYED"
        case .student:
            return "STUDENT"
        case .retired:
            return "RETIRED"
        case .entrepreneur:
            return "ENTREPRENEUR"
        }
    }
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
        case 5: return true
        default: return false
        }
    }
    func formatDateForBackend(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.string(from: date)
        }
}
struct OnboardingRequestDTO: Codable {
    let name: String
    let birthDate: String
    let gender: String
    let relationshipStatus: String
    let employmentStatus: String
}
