import SwiftUI
import SwiftData

struct LightShadowEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var model: LightShadowModel?
    
    @State private var observation = ""
    @State private var selectedShadow: ShadowCharacted = .sharp
    @State private var drawingData: Data? = nil
    @State private var analysis = ""
    @State private var drawMode: DrawMode = .draw
    @State private var lineWidth: CGFloat = 2.0
    
    init(model: LightShadowModel? = nil) {
        self.model = model
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color("appBrown"))
                }
                Spacer()
                Text("LIGHT & SHADOW")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("appBrown"))
                    .padding(.vertical, 5)
                Spacer()
                Color.clear.frame(width: 44, height: 1)
            }
            .padding(.top, 10)
            .padding(.horizontal)
            
            ScrollView {
                
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Observation")
                        .foregroundColor(Color("appBrown"))
                        .fontWeight(.semibold)
                    TextField("Observation", text: $observation)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color("appBrown"), lineWidth: 1)
                        )
                    
                    Text("Shadow Character")
                        .foregroundColor(Color("appBrown"))
                        .fontWeight(.semibold)
                    HStack(spacing: 12) {
                        ForEach(ShadowCharacted.allCases, id: \.self) { shadow in
                            Button {
                                selectedShadow = shadow
                            } label: {
                                Text(shadow.rawValue.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedShadow == shadow
                                        ? Color.appOrange
                                        : Color(.white)
                                    )
                                    .foregroundColor(selectedShadow == shadow ? .white : Color("appBrown"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color("appBrown"), lineWidth: 1)
                                    )
                                    .cornerRadius(18)
                            }
                        }
                    }
                    
                    Text("Sketch")
                        .foregroundColor(Color("appBrown"))
                        .fontWeight(.semibold)
                    
                    DrawingPad(
                        drawMode: $drawMode,
                        drawingData: $drawingData,
                        lineWidth: $lineWidth,
                        modelID: model?.id
                    )
                    .frame(height: 260)
                    .background(Color(.white))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("appBrown"), lineWidth: 1)
                    )
                    
                    HStack(spacing: 18) {
                        Button {
                            drawMode = .draw
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(6)
                                .background(
                                    drawMode == .draw
                                    ? Color("appOrange").opacity(0.15)
                                    : Color.clear
                                )
                                .cornerRadius(8)
                                .foregroundColor(Color("appBrown"))
                        }
                        
                        Button {
                            drawMode = .erase
                        } label: {
                            Image(systemName: "eraser")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(6)
                                .background(
                                    drawMode == .erase
                                    ? Color("appOrange").opacity(0.15)
                                    : Color.clear
                                )
                                .cornerRadius(8)
                                .foregroundColor(Color("appBrown"))
                        }
                        
                        Text("Size")
                            .foregroundColor(Color("appBrown"))
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                        
                        Slider(value: $lineWidth, in: 1...10)
                            .frame(width: 90)
                        
                        Spacer()
                        
                        Button {
                            drawingData = nil
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(6)
                                .foregroundColor(Color("appBrown"))
                        }
                    }
                    .padding(.horizontal, 5)
                    
                    Text("Draw the silhouette or light contrast")
                        .foregroundColor(Color("appBrown").opacity(0.7))
                        .font(.footnote)
                        .padding(.top, -6)
                }
                .padding(.horizontal)
                
                Text("Analysis")
                    .foregroundColor(Color("appBrown"))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextEditor(text: $analysis)
                    .frame(height: 60)
                    .padding(4)
                    .background(Color(.white))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("appBrown"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    if let model = model {
                        model.observation = observation
                        model.shadow = selectedShadow
                        model.drawing = drawingData ?? Data()
                        model.analysis = analysis
                    } else {
                        let new = LightShadowModel(
                            observation: observation,
                            shadow: selectedShadow,
                            drawing: drawingData ?? Data(),
                            analysis: analysis
                        )
                        context.insert(new)
                    }
                    try? context.save()
                    dismiss()
                } label: {
                    Text(model == nil ? "Save" : "Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appOrange)
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
            if let model = model {
                observation = model.observation
                selectedShadow = model.shadow
                drawingData = model.drawing
                analysis = model.analysis
            }
        }
    }
}

enum DrawMode {
    case draw, erase
}

struct PathStroke: Identifiable, Codable {
    var id = UUID()
    var points: [CGPoint]
    var width: CGFloat
    var isErase: Bool
}
struct DrawingPad: View {
    @Binding var drawMode: DrawMode
    @Binding var drawingData: Data? // strokes в JSON
    @Binding var lineWidth: CGFloat
    var modelID: UUID?
    
    @State private var strokes: [PathStroke] = []
    @State private var isDrawing: Bool = false
    @State private var loadedModelID: UUID?
    
    var body: some View {
        ZStack {
            Color.white
            Canvas { context, _ in
                for stroke in strokes {
                    var path = Path()
                    guard !stroke.points.isEmpty else { continue }
                    path.move(to: stroke.points[0])
                    for point in stroke.points.dropFirst() {
                        path.addLine(to: point)
                    }
                    let style = StrokeStyle(lineWidth: stroke.width, lineCap: .round, lineJoin: .round)
                    context.stroke(
                        path,
                        with: stroke.isErase ? .color(.white) : .color(Color("appBrown")),
                        style: style
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = value.location
                        if !isDrawing {
                            strokes.append(
                                PathStroke(points: [point], width: lineWidth, isErase: drawMode == .erase)
                            )
                            isDrawing = true
                        } else {
                            strokes[strokes.count - 1].points.append(point)
                        }
                    }
                    .onEnded { _ in
                        isDrawing = false
                        saveStrokes()
                    }
            )
        }
        .cornerRadius(18)
        .onAppear { loadStrokesIfNeeded() }
        .onChange(of: modelID) { _ in loadStrokesIfNeeded() }
        .onChange(of: drawingData) { newValue in
            // Если drawingData сбросили — очисти strokes
            if newValue == nil {
                strokes = []
            }
        }
    }
    
    func saveStrokes() {
        if strokes.isEmpty {
            drawingData = nil
            return
        }
        if let encoded = try? JSONEncoder().encode(strokes) {
            drawingData = encoded
        }
    }
    
    func loadStrokesIfNeeded() {
        guard loadedModelID != modelID else { return }
        loadedModelID = modelID
        
        if let data = drawingData,
           let decoded = try? JSONDecoder().decode([PathStroke].self, from: data) {
            strokes = decoded
            print("[LOAD] Загружено \(strokes.count) strokes из drawingData")
        } else {
            strokes = []
            print("[LOAD] drawingData пуст или не декодируется, новый рисунок")
        }
    }
}
