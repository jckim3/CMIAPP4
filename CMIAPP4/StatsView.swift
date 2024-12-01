import SwiftUI
import Combine

struct StatsView: View {
    @State private var checkInCount: Int = 0
    @State private var checkOutCount: Int = 0
    @State private var cancellable: AnyCancellable?
    @State private var showAlert: Bool = false
    @State private var checkInRoomList: [UInt8] = []
    
    @State private var totalRooms: Int = 34
    @State private var availableRooms: Int = 10
    @State private var occupyRatio: Double = 0

    
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
                StatItemView(title: "Check-ins", value: "\(checkInCount)", action: {
                                    fetchTodayCheckInRoomList()
                                })
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Today's Check-In Rooms"), message: Text(checkInRoomListString()), dismissButton: .default(Text("OK")))
                                }
                StatItemView(title: "Check-outs", value: "\(checkOutCount)")
                //StatItemView(title: "Stay-throughs", value: "0")
                StatItemView(title: "Occupy Ratio", value: "\(String(format: "%.1f", occupyRatio))%")

            }
        }
        .padding()
        .onAppear {
            fetchTodayCheckInAndCheckOutCounts()
            fetchOccupyRatio()
        }
    }

    func fetchTodayCheckInAndCheckOutCounts() {
        // 오늘의 체크인 수를 가져오는 API 호출
         APIService.shared.fetchTodayCheckInCount { result in
             switch result {
             case .success(let checkInCount):
                 self.checkInCount = checkInCount
             case .failure(let error):
                 print("Error fetching check-in count: \(error)")
             }
         }

         // 기존 체크아웃 수를 가져오는 API 호출
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

    func checkInRoomListString() -> String {
            if checkInRoomList.isEmpty {
                return "No rooms checked in today."
            } else {
                return checkInRoomList.map { "\($0)" }.joined(separator: ", ")
            }
        }
    
    func fetchTodayCheckInRoomList() {
            // 오늘의 체크인된 방 리스트를 가져오는 API 호출
            APIService.shared.fetchTodayCheckInRoomList { result in
                switch result {
                case .success(let roomList):
                    self.checkInRoomList = roomList
                    self.showAlert = true
                case .failure(let error):
                    print("Error fetching room list: \(error)")
                }
            }
        }

    func fetchOccupyRatio() {
            APIService.shared.fetchRoomOccupancy { result in
                switch result {
                case .success(let response):
                    self.totalRooms = response.totalRooms
                    self.availableRooms = response.availableRooms
                    let occupiedRooms = totalRooms - availableRooms
                    self.occupyRatio = (Double(occupiedRooms) / Double(totalRooms)) * 100
                case .failure(let error):
                    print("Error fetching occupancy data: \(error)")
                }
            }
        }

}

struct StatItemView: View {
    let title: String
    let value: String
    var action: (() -> Void)? = nil
    
    var body: some View {
            Button(action: {
                action?()
            }) {
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
}
