import SwiftUI

struct TabBarView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            MusicView()
                .tabItem {
                    Image(.tab1)
                    Text("Music")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(selection == 0 ? .bold : .regular)
                }
                .tag(0)
            FlowerView()
                .tabItem {
                    Image(.tab2)
                    Text("Flowers")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(selection == 1 ? .bold : .regular)
                }
                .tag(1)
            ShadowLightView()
                .tabItem {
                    Image(.tab3)
                    Text("Shadows")
                        .foregroundColor(Color.appBrown)
                        .fontWeight(selection == 2 ? .bold : .regular)
                }
                .tag(2)
        }
        .accentColor(.appBrown)
    }
}
