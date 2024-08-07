import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            WeatherView()
                .edgesIgnoringSafeArea(.all)

        }
    }
}


#Preview {
    ContentView()
}
