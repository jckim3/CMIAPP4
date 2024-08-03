import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                ReservationsView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Reservations")
                    }
                ClosedRoomsView()
                    .tabItem {
                        Image(systemName: "lock")
                        Text("Closed Rooms")
                    }
            }
        }
    }
}

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

struct CalendarView: View {
    var body: some View {
        Text("Calendar View")
    }
}

struct ReservationsView: View {
    var body: some View {
        Text("Reservations View")
    }
}

struct ClosedRoomsView: View {
    var body: some View {
        Text("Closed Rooms View")
    }
}

struct HeaderView: View {
    @State private var showSettings: Bool = false
    @State private var currentDate: String = ""

    var body: some View {
        ZStack {
            Image("carriagemotorinn_logo") // 에셋에 추가한 이미지 이름
                .resizable()
                .scaledToFill()
                .opacity(0.3) // 투명도를 높여 선명하게
                .frame(height: 80) // 필요에 따라 높이를 조절
                .clipped() // 이미지가 넘치지 않도록 자르기

            HStack {
                Text(currentDate)
                    .font(.headline)
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.red.opacity(0.1))
            }
            .padding(.horizontal)
        }
        .background(Color.red)
        .onAppear {
            currentDate = currentDateString()
        }
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
}

struct StatsView: View {
    @State private var checkInCount: Int = 0
    @State private var checkOutCount: Int = 0
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("오늘")
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
        let baseURL = "https://www.carriagemotorinn.com:444/api/motel" // API의 기본 URL
        guard let url = URL(string: "\(baseURL)/rooms/today-checkin-checkout") else {
            print("Invalid URL")
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Response status code: \(response.statusCode)")
                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: TodayCheckInOutResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                },
                receiveValue: { response in
                    self.checkInCount = response.todayCheckIns
                    self.checkOutCount = response.todayCheckOuts
                }
            )
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

struct AvailabilityView: View {
    @State private var availableRoomsCount: Int = 0
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Availability")
                .font(.headline)
            // 숫자만 표시
            Text("\(availableRoomsCount)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        .onAppear {
            fetchAvailableRoomsCount()
        }
    }
    
    func fetchAvailableRoomsCount() {
        let baseURL = "https://www.carriagemotorinn.com:444/api/motel" // API의 기본 URL
        guard let url = URL(string: "\(baseURL)/available-rooms-count") else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Response status code: \(response.statusCode)")
                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: Int.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                },
                receiveValue: { availableRoomsCount in
                    self.availableRoomsCount = availableRoomsCount
                }
            )
    }
}

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
        let baseURL = "https://www.carriagemotorinn.com:444/api/motel" // API의 기본 URL
        guard let url = URL(string: "\(baseURL)/sales/current-month") else {
            message = "Invalid URL"
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Response status code: \(response.statusCode)")
                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: SalesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        message = "Error: \(error.localizedDescription)"
                        print("Error: \(error)")
                    }
                },
                receiveValue: { salesResponse in
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
                }
            )
    }
    
    func fetchRoomRentStatus() {
        let baseURL = "https://www.carriagemotorinn.com:444/api/motel" // API의 기본 URL
        guard let url = URL(string: "\(baseURL)/rooms/payment-types") else {
            message = "Invalid URL"
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Response status code: \(response.statusCode)")
                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: PaymentTypeCounts.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        message = "Error: \(error.localizedDescription)"
                        print("Error: \(error)")
                    }
                },
                receiveValue: { paymentTypeCounts in
                    roomSoldSummary = "Daily: \(paymentTypeCounts.da), Weekly: \(paymentTypeCounts.wk), Monthly: \(paymentTypeCounts.mo), Week Voucher: \(paymentTypeCounts.wc), Master Lease: \(paymentTypeCounts.ml)"
                }
            )
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

// Define the SalesResponse struct to decode the API response
struct SalesResponse: Codable {
    let totalPrice: Double
    let totalCreditPrice: Double
}

// Define the PaymentTypeCounts struct to decode the API response for room rent status
struct PaymentTypeCounts: Codable {
    let da: Int
    let wk: Int
    let mo: Int
    let wc: Int
    let ml: Int
}

// Define the TodayCheckInOutResponse struct to decode the API response for today's check-ins and check-outs
struct TodayCheckInOutResponse: Codable {
    let todayCheckIns: Int
    let todayCheckOuts: Int
}

// 새로운 설정 뷰
struct SettingsView: View {
    var body: some View {
        VStack {
            // 오늘 날짜 표시
            Text("App Created on \(getAppCreationDate())")
                .font(.headline)
                .padding()

            Spacer()
            
            // Back 버튼
            Button(action: {
                // 돌아가기 액션
            }) {
                Text("Back")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding()
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
    
    func getAppCreationDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        // 앱의 생성 날짜를 정적 날짜로 설정
        let creationDate = Date(timeIntervalSince1970: 1688294400) // 특정 생성 날짜 설정
        return formatter.string(from: creationDate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
