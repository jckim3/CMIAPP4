//
//  CalendarView.swift
//  CMIAPP4
//
//  Created by JC Kim on 9/1/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())

    var body: some View {
        VStack(spacing: 20) {
            Text("HelloCalendar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // 년 선택 Picker
            Picker("Select Year", selection: $selectedYear) {
                ForEach(2000..<2101) { year in
                    Text("\(year)년").tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(height: 100)

            // 월 선택 Picker
            Picker("Select Month", selection: $selectedMonth) {
                ForEach(1..<13) { month in
                    Text("\(month)월").tag(month)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(height: 100)

            // 선택된 년월 표시
            Text("Selected Date: \(formattedDate(year: selectedYear, month: selectedMonth))")
                .font(.headline)
                .padding()
        }
        .padding()
    }

    func formattedDate(year: Int, month: Int) -> String {
        return "\(year)년 \(month)월"
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}


