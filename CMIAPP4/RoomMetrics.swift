//
//  RoomMetrics.swift
//  CMIAPP4
//
//  Created by JC Kim on 1/15/25.
//

import SwiftUI

struct RoomMetricsView: View {
    @State private var selectedMonth = 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var roomMetrics: [RoomMetric] = [] // API 데이터를 저장할 상태 변수
    @State private var isLoading = false // 로딩 상태 표시
    @State private var errorMessage: String? // 에러 메시지

    var body: some View {
        VStack(spacing: 20) {
            Text("Room Metrics View")
                .font(.title)
                .padding()

            // Custom Year and Month Picker
            HStack {
                Picker("Year", selection: $selectedYear) {
                    ForEach(2022...2035, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 120)
                .clipped()

                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month)").tag(month)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 120)
                .clipped()
            }
            .padding()

            // Display selected Year and Month
            Text("Selected: \(selectedYear)-\(String(format: "%02d", selectedMonth))")
                .font(.headline)
                .padding()

            // Room Metrics List
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if roomMetrics.isEmpty {
                Text("No data available for the selected year and month.")
                    .padding()
            } else {
                ScrollView(.vertical) {
                    VStack(spacing: 10) {
                        ForEach(roomMetrics) { metric in
                            VStack(alignment: .leading) {
                                Text("Date: \(metric.date)")
                                    .font(.headline)
                                Text("Total Rooms: \(metric.totalRooms)")
                                Text("Occupied Rooms: \(metric.occupiedRooms)")
                                Text("Occupancy Ratio: \(metric.occupancyRatio, specifier: "%.2f")")
                                Text("Total Revenue: $\(metric.totalRevenue, specifier: "%.2f")")
                                Text("ADR: $\(metric.adr, specifier: "%.2f")")
                                Text("REVPAR: $\(metric.revpar, specifier: "%.2f")")
                                Text("Profit Per Room: $\(metric.profitPerRoom, specifier: "%.2f")")
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }

            Spacer()

            // Get Room Metrics Button
            Button(action: fetchRoomMetrics) {
                Text("Get Room Metrics")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    private func fetchRoomMetrics() {
           isLoading = true
           errorMessage = nil

           APIService.shared.fetchRoomMetrics(year: selectedYear, month: selectedMonth) { result in
               DispatchQueue.main.async {
                   isLoading = false
                   switch result {
                   case .success(let metrics):
                       roomMetrics = metrics
                   case .failure(let error):
                       errorMessage = "Error: \(error.localizedDescription)"
                   }
               }
           }
       }

    
    // 날짜 계산
    private func daysInMonth(year: Int, month: Int) -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
}

// Room Metric 모델 정의
struct RoomMetric: Identifiable, Codable {
    let id: Int
    let date: String
    let totalRooms: Int
    let occupiedRooms: Int
    let occupancyRatio: Double
    let totalRevenue: Double
    let adr: Double
    let revpar: Double
    let profitPerRoom: Double

    enum CodingKeys: String, CodingKey {
        case id = "roomMetricsId"
        case date = "roomMetricsDate"
        case totalRooms = "total_Rooms"
        case occupiedRooms = "occupied_Rooms"
        case occupancyRatio = "occupancy_Ratio"
        case totalRevenue = "total_Revenue"
        case adr = "adr"
        case revpar = "revpar"
        case profitPerRoom = "profit_Per_Room"
    }
}

