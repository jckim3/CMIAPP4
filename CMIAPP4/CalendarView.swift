//
//  CalendarView.swift
//  CMIAPP4
//
//  Created by JC Kim on 9/1/24.
//

import SwiftUI

import SwiftUI

struct CalendarView: View {
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @ObservedObject var viewModel = RevenueViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Revenue for Selected Year")
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

            // Get Revenue 버튼
            Button(action: {
                viewModel.fetchRevenue(for: selectedYear)
            }) {
                Text("Get Revenue for \(selectedYear)년")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // Revenue 리스트 표시
            List(viewModel.revenues) { revenue in
                VStack(alignment: .leading) {
                    Text("\(revenue.month)월")
                        .font(.headline)
                    Text("현금: \(formattedAmount(revenue.cashRevenue))")
                    Text("신용카드: \(formattedAmount(revenue.creditRevenue))")
                    Text("총 매출: \(formattedAmount(revenue.totalRevenue))")
                }
                .padding()
            }
        }
        .padding()
    }
    // 금액을 $와 콤마로 포맷팅하는 함수
        func formattedAmount(_ amount: Decimal) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 2
            return formatter.string(from: amount as NSNumber) ?? "$0.00"
        }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}


