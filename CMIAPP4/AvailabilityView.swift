//
//  AvailabilityView.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

import SwiftUI
import Combine

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
        APIService.shared.fetchAvailableRoomsCount { result in
            switch result {
            case .success(let count):
                self.availableRoomsCount = count
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}
