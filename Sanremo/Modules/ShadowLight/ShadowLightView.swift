import SwiftUI
import SwiftData

struct ShadowLightView: View {
    @Environment(\.modelContext) private var context
    @Query private var allEntries: [LightShadowModel]
    @State private var showEntry = false
    @State private var editModel: LightShadowModel?
    @State private var showFilterMenu = false
    @State private var selectedFilter: ShadowCharacted? = nil

    var filteredEntries: [LightShadowModel] {
        if let filter = selectedFilter {
            return allEntries.filter { $0.shadow == filter }
        } else {
            return allEntries
        }
    }

    var body: some View {
        ZStack {
            Color(red: 249/255, green: 241/255, blue: 225/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Color.clear.frame(width: 44, height: 1)
                    Spacer()
                    Text("LIGHT & SHADOW")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("appBrown"))
                        .padding(.vertical, 24)
                    Spacer()
                    Button {
                        withAnimation { showFilterMenu.toggle() }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .frame(width: 44, height: 44)
                            .foregroundColor(Color("appBrown"))
                            .padding(.trailing, 16)
                            .padding(.top, 8)
                    }
                }
                .padding(.top, 2)
                .zIndex(2)

                if showFilterMenu {
                    ZStack(alignment: .topTrailing) {
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 0) {
                                HStack(spacing: 0) {
                                    Button {
                                        selectedFilter = nil
                                        showFilterMenu = false
                                    } label: {
                                        Text("All")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 20)
                                            .background(selectedFilter == nil ? Color("appBrown") : Color.clear)
                                            .foregroundColor(selectedFilter == nil ? .white : Color("appBrown"))
                                            .cornerRadius(16)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                ForEach(ShadowCharacted.allCases, id: \.self) { kind in
                                    Button {
                                        selectedFilter = kind
                                        showFilterMenu = false
                                    } label: {
                                        Text(kind.rawValue.capitalized)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 20)
                                            .background(selectedFilter == kind ? Color("appBrown") : Color.clear)
                                            .foregroundColor(selectedFilter == kind ? .white : Color("appBrown"))
                                            .cornerRadius(16)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .background(Color(red: 249/255, green: 241/255, blue: 225/255))
                            .padding(.trailing, 14)
                            .padding(.top, -15)
                        }
                    }
                }

                if filteredEntries.isEmpty {
                    VStack {
                        Spacer()
                        Text("No light & shadow notes yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("appBrown"))
                            .padding(.bottom, 6)
                        Text("Start observing how light shapes the world around you. Tap + to add your first observation.")
                            .foregroundColor(Color(.appBrown).opacity(0.6))
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredEntries) { item in
                            ShadowLightCardView(model: item)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        editModel = item
                                        showEntry = true
                                    } label: {
                                        Image(.editBtn)
                                    }
                                    .tint(Color.clear)

                                    Button {
                                        context.delete(item)
                                    } label: {
                                        Image(.delBtn)
                                    }
                                    .tint(Color.clear)
                                }
                                .onTapGesture {
                                    editModel = item
                                    showEntry = true
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
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
            LightShadowEntryView(model: editModel)
        }
    }
}

struct ShadowLightCardView: View {
    let model: LightShadowModel

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            DrawingCardPreview(drawingData: model.drawing)
                .frame(width: 68, height: 68)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.leading, 7)
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 6) {
                Text(model.observation)
                    .font(.headline)
                    .foregroundColor(Color("appBrown"))
                    .fixedSize(horizontal: false, vertical: true)
                Text(model.shadow.rawValue.capitalized)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(.white))
                    .foregroundColor(Color("appBrown"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("appBrown"), lineWidth: 1)
                    )
                    .cornerRadius(14)
                if !model.analysis.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(model.analysis)
                        .font(.footnote.italic())
                        .foregroundColor(Color("appBrown").opacity(0.75))
                        .padding(.top, 8)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 10)
            .padding(.trailing, 10)
            Spacer()
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
    }
}

struct DrawingCardPreview: View {
    let drawingData: Data?
    let referenceSize: CGSize = CGSize(width: 320, height: 240) // базовый canvas из редактора

    var strokes: [PathStroke]? {
        if let data = drawingData,
           let decoded = try? JSONDecoder().decode([PathStroke].self, from: data) {
            return decoded
        }
        return nil
    }
    var fallbackImage: UIImage? {
        if let data = drawingData, let img = UIImage(data: data) { return img }
        return nil
    }

    var body: some View {
        GeometryReader { geometry in
            if let strokes = strokes, !strokes.isEmpty {
                // Пропорционально уменьшаем strokes под 68x68
                let sx = geometry.size.width / referenceSize.width
                let sy = geometry.size.height / referenceSize.height
                Canvas { context, size in
                    for stroke in strokes {
                        var path = Path()
                        guard !stroke.points.isEmpty else { continue }
                        let tPoints = stroke.points.map { CGPoint(x: $0.x * sx, y: $0.y * sy) }
                        path.move(to: tPoints[0])
                        for point in tPoints.dropFirst() {
                            path.addLine(to: point)
                        }
                        let style = StrokeStyle(lineWidth: stroke.width * sx, lineCap: .round, lineJoin: .round)
                        context.stroke(
                            path,
                            with: stroke.isErase ? .color(.white) : .color(Color("appBrown")),
                            style: style
                        )
                    }
                }
            } else if let img = fallbackImage {
                // Для legacy PNG
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear // пусто
            }
        }
    }
}
