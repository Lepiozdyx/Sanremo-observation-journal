import SwiftUI
import SwiftData

struct MusicEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var music: MusicModel?
    
    @State private var songTitle = ""
    @State private var artist = ""
    @State private var impression = ""
    @State private var selectedMood: Mood = .nostalgia
    @State private var date = Date()
    
    init(music: MusicModel? = nil) {
        self.music = music
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color.appBrown)
                }
                Spacer()
                Text(music == nil ? "MUSIC ENTRY" : "EDIT ENTRY")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.appBrown)
                    .padding(.vertical, 5)
                Spacer()
                Color.clear.frame(width: 44, height: 1)
            }
            .padding(.top, 10)
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Song Title")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(.semibold)
                    TextField("Volare", text: $songTitle)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.appBrown, lineWidth: 1)
                        )
                    
                    Text("Artist")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(.semibold)
                    TextField("Domenico Modugno", text: $artist)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.appBrown, lineWidth: 1)
                        )
                    
                    Text("Impressions")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(.semibold)
                    TextEditor(text: $impression)
                        .frame(height: 70)
                        .padding(4)
                        .background(Color(.white))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.appBrown, lineWidth: 1)
                        )
                    
                    Text("Mood")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(.semibold)
                    moodButtons
                    
                    Text("Date&Time")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(.semibold)
                    HStack {
                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: .date
                        )
                        .environment(\.locale, Locale(identifier: "en_GB"))
                        
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .padding(8)
                        .background(Color(.white))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.appBrown, lineWidth: 1)
                        )
                        
                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .padding(8)
                        .background(Color(.white))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.appBrown, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    if let music = music {
                        music.songTitle = songTitle
                        music.artist = artist
                        music.impression = impression
                        music.mood = selectedMood
                        music.date = date
                    } else {
                        let newMusic = MusicModel(songTitle: songTitle, artist: artist, impression: impression, mood: selectedMood, date: date)
                        context.insert(newMusic)
                    }
                    try? context.save()
                    dismiss()
                } label: {
                    Text(music == nil ? "Save" : "Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .hideKeyboardOnTap()
        .background(Color(red: 249/255, green: 241/255, blue: 225/255))
        .ignoresSafeArea(.container, edges: [.bottom])
        .onAppear {
            if let music = music {
                songTitle = music.songTitle
                artist = music.artist
                impression = music.impression
                selectedMood = music.mood
                date = music.date
            }
        }
    }
    
    private var moodButtons: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                moodButton(.nostalgia)
                moodButton(.inspiration)
                moodButton(.joy)
                Spacer()
            }
            HStack(spacing: 12) {
                moodButton(.sadness)
                moodButton(.energy)
                Spacer()
            }
        }
    }
    
    private func moodButton(_ mood: Mood) -> some View {
        Button {
            selectedMood = mood
        } label: {
            Text(mood.rawValue.capitalized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 22)
                .padding(.vertical, 8)
                .background(
                    selectedMood == mood
                    ? Color.appOrange
                    : Color(.white)
                )
                .foregroundColor(selectedMood == mood ? .white : Color.appOrange)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.appOrange, lineWidth: 1)
                )
                .cornerRadius(18)
        }
    }
}
