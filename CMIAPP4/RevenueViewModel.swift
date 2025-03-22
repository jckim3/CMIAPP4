//
//  RevenueViewModel.swift
//  CMIAPP4
//
//  Created by JC Kim on 9/2/24.
//

import SwiftUI
import Foundation
import Combine

class RevenueViewModel: ObservableObject {
    @Published var revenues: [Revenue] = []
    private var cancellables = Set<AnyCancellable>()
    var totalCashRevenue: Decimal? {
           revenues.reduce(Decimal(0)) { $0 + $1.cashRevenue }
       }

       var totalCreditRevenue: Decimal? {
           revenues.reduce(Decimal(0)) { $0 + $1.creditRevenue }
       }

       var totalRevenue: Decimal? {
           revenues.reduce(Decimal(0)) { $0 + $1.totalRevenue }
       }
    // 평균 매출 (총 매출 금액 / 12)
 //   var averageRevenue: Decimal? {
 //       guard let totalRevenue = totalRevenue else { return nil }
 //       return totalRevenue / Decimal(12)
 //   }
    
    var averageRevenue: Decimal? {
        let monthsWithRevenue = revenues.filter { $0.totalRevenue > 0 }
        let total = monthsWithRevenue.reduce(Decimal(0)) { $0 + $1.totalRevenue }
        let count = monthsWithRevenue.count

        guard count > 0 else { return nil }

        return total / Decimal(count)
    }
    func fetchRevenue(for year: Int) {
        APIService.shared.fetchRevenue(for: year) { [weak self] result in
            switch result {
            case .success(let monthlyRevenues):
                            DispatchQueue.main.async {
                                // API에서 이미 합산된 데이터를 그대로 사용
                                self?.revenues = monthlyRevenues.map { data in
                                    Revenue(
                                        month: data.month,
                                        cashRevenue: data.cashRevenue,
                                        creditRevenue: data.creditRevenue,
                                        totalRevenue: data.totalRevenue
                                    )
                                }
                            }
            case .failure(let error):
                print("Failed to fetch revenue data: \(error)")
            }
        }
    }
}

