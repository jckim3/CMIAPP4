//
//  PerformanceItemView.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

import SwiftUI

struct PerformanceItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct PerformanceItemView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceItemView(title: "Sample Title", value: "Sample Value")
            .previewLayout(.sizeThatFits)
    }
}
