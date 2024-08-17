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
           
           // UserDefaults에 저장된 앱 생성 날짜를 불러옴
           if let savedDate = UserDefaults.standard.string(forKey: "AppCreationDate") {
               return savedDate
           } else {
               // 처음 실행 시 앱 생성 날짜를 현재 날짜로 설정하고 UserDefaults에 저장
               let creationDate = Date()
               let creationDateString = formatter.string(from: creationDate)
               UserDefaults.standard.set(creationDateString, forKey: "AppCreationDate")
               return creationDateString
           }
       }
}
