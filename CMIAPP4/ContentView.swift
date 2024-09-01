//
//  ContentView.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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

#Preview {
    ContentView()
}
