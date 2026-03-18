import SwiftUI
import SwiftData
import PhotosUI

struct FlowerEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var flower: FlowerModel?

    @State private var name = ""
    @State private var details = ""
    @State private var date = Date()
    @State private var imageData: Data?
    @State private var showPicker = false

    init(flower: FlowerModel? = nil) {
        self.flower = flower
    }

    var body: some View {
        VStack(spacing: 28) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color("appBrown"))
                }
                Spacer()
            }
            .padding(.top, 10)
            .padding(.horizontal)
            
            ScrollView {
                Text("FLOWER ENTRY")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("appBrown"))
                    .padding(.vertical, 5)
                
                VStack(spacing: 16) {
                    ZStack {
                        if let imgData = imageData, let uiImage = UIImage(data: imgData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 112, height: 112)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .overlay(
                                    Button {
                                        imageData = nil
                                    } label: {
                                        Circle()
                                            .fill(Color("appBrown"))
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 16, weight: .bold))
                                            )
                                    }
                                    //                                .offset(x: 42, y: -42)
                                    , alignment: .topTrailing
                                )
                        } else {
                            Button { showPicker = true } label: {
                                VStack(spacing: 7) {
                                    Image("flowerUpload")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text("PHOTO OF THE\nPACKAGING")
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color("appBrown"))
                                }
                                .padding(22)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color("appBrown"), style: StrokeStyle(lineWidth: 1, dash: [6]))
                                )
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name / Description")
                            .foregroundColor(Color("appBrown"))
                            .fontWeight(.semibold)
                        TextField("Name / Description", text: $name)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color("appBrown"), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Details")
                            .foregroundColor(Color("appBrown"))
                            .fontWeight(.semibold)
                        TextEditor(text: $details)
                            .frame(height: 70)
                            .padding(4)
                            .background(Color(.white))
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color("appBrown"), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text(dateString(date))
                    .foregroundColor(Color("appBrown"))
                    .font(.title3)
                    .padding(.bottom, 8)
                
                Button {
                    if let flower = flower {
                        flower.name = name
                        flower.details = details
                        flower.image = imageData ?? Data()
                        flower.date = date
                    } else {
                        let saveData = imageData ?? Data()
                        let newFlower = FlowerModel(name: name, details: details, image: saveData, date: date)
                        context.insert(newFlower)
                    }
                    try? context.save()
                    dismiss()
                } label: {
                    Text(flower == nil && imageData == nil ? "Save to Archive" : "Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(flower == nil && imageData == nil ? Color(.systemGray3) : Color.appOrange)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
                .disabled(name.isEmpty || details.isEmpty)
            }
        }
        .hideKeyboardOnTap()
        .background(Color(red: 249/255, green: 241/255, blue: 225/255))
        .ignoresSafeArea(.container, edges: [.bottom])
        .onAppear {
            if let flower = flower {
                name = flower.name
                details = flower.details
                date = flower.date
                imageData = flower.image
            }
        }
        .sheet(isPresented: $showPicker) {
            PhotoPicker(data: $imageData)
        }
    }

    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL, yyyy"
        return formatter.string(from: date).capitalized
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var data: Data?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        init(_ parent: PhotoPicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let uiImage = image as? UIImage, let data = uiImage.jpegData(compressionQuality: 0.8) {
                        DispatchQueue.main.async {
                            self.parent.data = data
                        }
                    }
                }
            }
        }
    }
}
