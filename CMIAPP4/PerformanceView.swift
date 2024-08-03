import SwiftUI
import Combine

struct PerformanceView: View {
    @State private var selectedView = "Rooms sold"
    @State private var message: String = ""
    @State private var currentMonthSales: String = "0"
    @State private var cashSales: String = "0"
    @State private var creditSales: String = "0"
    @State private var roomSoldSummary: String = "Loading..."
    @State private var cancellable: AnyCancellable?
    let options = ["Rooms sold", "Revenue"]

    var body: some View {
        VStack(spacing: 10) {
            Text("Performance")
                .font(.headline)
            
            Picker("Select View", selection: $selectedView) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedView) { newValue in
                if newValue == "Revenue" {
                    fetchCurrentMonthSales()
                } else {
                    fetchRoomRentStatus()
                }
            }
            
            if selectedView == "Rooms sold" {
                PerformanceItemView(title: "Room Sold", value: roomSoldSummary)
            } else {
                PerformanceItemView(title: "Revenue", value: "$\(currentMonthSales)")
                PerformanceItemView(title: "Cash Sales", value: "$\(cashSales)")
                PerformanceItemView(title: "Credit Sales", value: "$\(creditSales)")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        .onAppear {
            fetchRoomRentStatus()
        }
    }
    
    func fetchCurrentMonthSales() {
        APIService.shared.fetchCurrentMonthSales { result in
            switch result {
            case .success(let salesResponse):
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0 // 소수점 표시하지 않음

                // 각 판매 값 포맷팅
                let formattedTotalPrice = formatter.string(from: NSNumber(value: salesResponse.totalPrice)) ?? "\(salesResponse.totalPrice)"
                let formattedTotalCreditPrice = formatter.string(from: NSNumber(value: salesResponse.totalCreditPrice)) ?? "\(salesResponse.totalCreditPrice)"
                let totalSales = salesResponse.totalPrice + salesResponse.totalCreditPrice
                let formattedTotalSales = formatter.string(from: NSNumber(value: totalSales)) ?? "\(totalSales)"

                // 상태 변수 업데이트
                currentMonthSales = formattedTotalSales
                cashSales = formattedTotalPrice
                creditSales = formattedTotalCreditPrice
            case .failure(let error):
                message = "Error: \(error.localizedDescription)"
                print("Error: \(error)")
            }
        }
    }
    
    func fetchRoomRentStatus() {
        APIService.shared.fetchRoomRentStatus { result in
            switch result {
            case .success(let paymentTypeCounts):
                roomSoldSummary = "Daily: \(paymentTypeCounts.da), Weekly: \(paymentTypeCounts.wk), Monthly: \(paymentTypeCounts.mo), Week Voucher: \(paymentTypeCounts.wc), Master Lease: \(paymentTypeCounts.ml)"
            case .failure(let error):
                message = "Error: \(error.localizedDescription)"
                print("Error: \(error)")
            }
        }
    }
}

struct PerformanceItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct PerformanceView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
    }
}
