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
            Text("App Created on \(getAppCreationDateString())")
                .font(.headline)
                .padding()

            // 앱 정지 경고 메시지
            if let daysRemaining = getDaysRemainingBeforeSuspension() {
                Text("App will be suspended in \(daysRemaining) days.")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding()
            } 
            
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
    
    func getAppCreationDateString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            // UserDefaults에 저장된 앱 생성 날짜를 불러옴
            if let savedDate = UserDefaults.standard.object(forKey: "AppCreationDate") as? Date {
                return formatter.string(from: savedDate)
            } else {
                // 처음 실행 시 앱 생성 날짜를 현재 날짜로 설정하고 UserDefaults에 저장
                let creationDate = Date()
                UserDefaults.standard.set(creationDate, forKey: "AppCreationDate")
                return formatter.string(from: creationDate)
            }
        }
    func getDaysRemainingBeforeSuspension() -> Int? {
            if let creationDate = UserDefaults.standard.object(forKey: "AppCreationDate") as? Date {
                let calendar = Calendar.current
                let suspensionDate = calendar.date(byAdding: .day, value: 10, to: creationDate)!

                let currentDate = Date()
                if currentDate < suspensionDate {
                    let remainingDays = calendar.dateComponents([.day], from: currentDate, to: suspensionDate).day
                    return remainingDays
                } else {
                    return 0 // 앱이 이미 정지되어야 하는 상태일 경우
                }
            }
            return nil
        }
    
}
