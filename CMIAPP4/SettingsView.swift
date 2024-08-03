//
//  SettingsView.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            // 오늘 날짜 표시
            Text("App Created on \(getAppCreationDate())")
                .font(.headline)
                .padding()

            Spacer()
            
            // Back 버튼
            Button(action: {
                // 돌아가기 액션
            }) {
                Text("Back")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding()
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
    
    func getAppCreationDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        // 앱의 생성 날짜를 정적 날짜로 설정
        let creationDate = Date(timeIntervalSince1970: 1688294400) // 특정 생성 날짜 설정
        return formatter.string(from: creationDate)
    }
}
