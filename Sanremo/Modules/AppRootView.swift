import SwiftUI
import SwiftData

struct AppRootView: View {
    var body: some View {
        TabBarView()
            .preferredColorScheme(.light)
            .modelContainer(for: [
                MusicModel.self,
                FlowerModel.self,
                LightShadowModel.self
            ])
    }
}

#Preview {
    AppRootView()
}
