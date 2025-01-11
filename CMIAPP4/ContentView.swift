import SwiftUI

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
                RoomMetricsView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Room Metrics")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RoomMetricsView: View {
    @State private var selectedMonth = 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedDay = 1


    var body: some View {
        VStack(spacing: 20) {
            Text("Room Metrics View")
                .font(.title)
                .padding()

            // Custom Year and Month Picker
            HStack {
                Picker("Year", selection: $selectedYear) {
                    ForEach(2022...2035, id: \ .self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 120)
                .clipped()

                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \ .self) { month in
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
            // Scrollable Days and Weekdays
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(1...daysInMonth(year: selectedYear, month: selectedMonth), id: \ .self) { day in
                        VStack {
                            Text("\(day)")
                                .font(.headline)
                            Text(weekday(for: day, month: selectedMonth, year: selectedYear))
                                .font(.subheadline)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            Spacer()
            // Get Room Metrics Button
            Button(action: {
                // Add action to get room metrics
                print("Getting room metrics for \(selectedYear)-\(String(format: "%02d", selectedMonth))")
            }) {
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
    private func daysInMonth(year: Int, month: Int) -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }

    private func weekday(for day: Int, month: Int, year: Int) -> String {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let date = calendar.date(from: dateComponents)!
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Short weekday format (e.g., Mon, Tue)
        return formatter.string(from: date)
    }
}

struct ClosedRoomsView: View {
    var body: some View {
        Text("Closed Rooms View")
    }
}

#Preview {
    ContentView()
}
