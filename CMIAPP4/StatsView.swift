import SwiftUI
import Combine

struct StatsView: View {
    @State private var checkInCount: Int = 0
    @State private var checkOutCount: Int = 0
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .foregroundColor(.black)
                Spacer()
            }
            HStack {
                StatItemView(title: "Check-ins", value: "\(checkInCount)")
                StatItemView(title: "Check-outs", value: "\(checkOutCount)")
                StatItemView(title: "Stay-throughs", value: "0")
            }
        }
        .padding()
        .onAppear {
            fetchTodayCheckInAndCheckOutCounts()
        }
    }

    func fetchTodayCheckInAndCheckOutCounts() {
        APIService.shared.fetchTodayCheckInAndCheckOutCounts { result in
            switch result {
            case .success(let response):
                self.checkInCount = response.todayCheckIns
                self.checkOutCount = response.todayCheckOuts
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}

struct StatItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
