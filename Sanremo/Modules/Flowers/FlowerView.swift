import SwiftUI
import SwiftData

struct FlowerView: View {
    @Environment(\.modelContext) private var context
    @Query private var entries: [FlowerModel]
    @State private var showEntry = false
    @State private var editModel: FlowerModel?

    var cellWidth: CGFloat {
        UIScreen.main.bounds.width / 2 - 16
    }

    var body: some View {
        ZStack {
            Color(red: 249/255, green: 241/255, blue: 225/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("FLOWER ENTRY")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("appBrown"))
                    .padding(.vertical, 24)

                if entries.isEmpty {
                    VStack {
                        Spacer()
                        Text("No flower memories yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("appBrown"))
                            .padding(.bottom, 6)
                        Text("Save your first flower and capture the moment it bloomed. Tap + to add your first flower entry.")
                            .foregroundColor(Color(.appBrown).opacity(0.6))
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.fixed(cellWidth), spacing: 10),
                            GridItem(.fixed(cellWidth), spacing: 10)
                        ], spacing: 18) {
                            ForEach(entries) { flower in
                                FlowerCardView(flower: flower, width: cellWidth)
                                    .onTapGesture {
                                        editModel = flower
                                        showEntry = true
                                    }
                                    .contextMenu {
                                        Button("Edit") {
                                            editModel = flower
                                            showEntry = true
                                        }
                                        Button("Delete", role: .destructive) {
                                            context.delete(flower)
                                            try? context.save()
                                        }
                                    }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                        Spacer()
                    }
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
            FlowerEntryView(flower: editModel)
        }
    }
}

struct FlowerCardView: View {
    let flower: FlowerModel
    let width: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let image = UIImage(data: flower.image) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: width * 0.66)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .clipped()
            } else {
                Color.clear
                    .frame(width: width, height: width * 0.66)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(flower.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("appBrown"))
                Text(dateString(flower.date))
                    .foregroundColor(Color("appBrown").opacity(0.8))
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.white))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color("appBrown"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .frame(width: width)
    }

    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL, yyyy"
        return formatter.string(from: date).capitalized
    }
}
