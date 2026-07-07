import Foundation

struct BoltItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var pattern: String
    var bin: String
    var notes: String = ""
    var dateAdded: Date = Date()
}
