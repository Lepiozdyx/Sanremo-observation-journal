import SwiftData
import Foundation

@Model
class MusicModel {
    var id = UUID()
    
    var songTitle: String
    var artist: String
    var impression: String
    var mood: Mood
    var date: Date
    
    init(id: UUID = UUID(), songTitle: String, artist: String, impression: String, mood: Mood, date: Date) {
        self.id = id
        self.songTitle = songTitle
        self.artist = artist
        self.impression = impression
        self.mood = mood
        self.date = date
    }
}

enum Mood: String, CaseIterable, Codable {
    case nostalgia, inspiration, joy, sadness, energy
    
}
