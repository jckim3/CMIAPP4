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
    @State private var selectedDate = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("Room Metrics View")
                .font(.title)
                .padding()

            // Year and Month selection
            DatePicker(
                "Select Year and Month",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            // Display selected Year/Month
            Text("Selected: \(formattedDate(selectedDate))")
                .font(.headline)
                .padding()
        }
        .padding()
    }

    // Format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
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
