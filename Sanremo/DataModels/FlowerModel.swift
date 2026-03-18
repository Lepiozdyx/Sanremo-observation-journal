import Foundation
import SwiftData

@Model
class FlowerModel {
    var id = UUID()
    
    var name: String
    var details: String
    var image: Data
    var date: Date
    
    init(id: UUID = UUID(), name: String, details: String, image: Data, date: Date) {
        self.id = id
        self.name = name
        self.details = details
        self.image = image
        self.date = date
    }
}
