import SwiftUI
import SwiftData

struct MusicView: View {
    @Environment(\.modelContext) private var context
    @Query private var entries: [MusicModel]
    @State private var showEntry = false
    @State private var editModel: MusicModel?

    var body: some View {
        ZStack {
            Color(red: 249/255, green: 241/255, blue: 225/255)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("MUSIC ENTRY")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("appBrown"))
                    .padding(.vertical, 24)
                
                if entries.isEmpty {
                    VStack {
                        Spacer()
                        Text("No music entries yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("appBrown"))
                            .padding(.bottom, 6)
                        Text("Start your first memory by adding a song that means something to you. Tap + to create your first music entry.")
                            .foregroundColor(Color(.appBrown).opacity(0.6))
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(entries) { music in
                            MusicCardView(music: music)
                                .listRowInsets(EdgeInsets())
                                .background(Color.clear)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        editModel = music
                                        showEntry = true
                                    } label: {
                                        Image("editBtn")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                    }
                                    .tint(Color.clear)

                                    Button(role: .destructive) {
                                        context.delete(music)
                                        try? context.save()
                                    } label: {
                                        Image("delBtn")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                    }
                                    .tint(Color.clear)
                                }
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .background(Color.clear)
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        editModel = nil
                        showEntry = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("appBrown"))
                                .frame(width: 56, height: 56)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .fullScreenCover(isPresented: $showEntry) { [editModel] in
            MusicEntryView(music: editModel)
        }
    }
}

struct MusicCardView: View {
    let music: MusicModel

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(music.songTitle)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("appBrown"))
                Text(music.artist)
                    .foregroundColor(Color("appBrown"))
                    .font(.subheadline)
                if !music.impression.isEmpty {
                    Text("\"\(music.impression)\"")
                        .foregroundColor(Color("appBrown").opacity(0.7))
                        .font(.subheadline)
                        .italic()
                }
                Text(dateString(music.date))
                    .foregroundColor(Color("appBrown").opacity(0.8))
                    .font(.caption)
                    .padding(.top, 4)
            }
            Spacer()
            Text(music.mood.rawValue.capitalized)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(Color(.white))
                .foregroundColor(Color("appBrown"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("appBrown"), lineWidth: 1)
                )
                .cornerRadius(16)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.white))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color("appBrown"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
