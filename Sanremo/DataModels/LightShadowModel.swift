import SwiftData
import Foundation

@Model
class LightShadowModel {
    var id = UUID()
    
    var observation: String
    var shadow: ShadowCharacted
    var drawing: Data
    var analysis: String
    
    init(id: UUID = UUID(), observation: String, shadow: ShadowCharacted, drawing: Data, analysis: String) {
        self.id = id
        self.observation = observation
        self.shadow = shadow
        self.drawing = drawing
        self.analysis = analysis
    }
}

enum ShadowCharacted: String, CaseIterable, Codable {
    case sharp, soft, dramatic, diffused
}
