import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding(.top, safeAreaInsets().top)
            StatsView()
            Divider()
            AvailabilityView()
            PerformanceView()
            Spacer()
        }
        .background(Color.orange.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
    }
    
    func safeAreaInsets() -> UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return .zero }
        return window.safeAreaInsets
    }
}
