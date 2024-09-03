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

    func fetchRevenue(for year: Int) {
        APIService.shared.fetchRevenue(for: year) { [weak self] result in
            switch result {
            case .success(let revenues):
                DispatchQueue.main.async {
                    self?.revenues = revenues
                }
            case .failure(let error):
                print("Failed to fetch revenue data: \(error)")
            }
        }
    }
}

