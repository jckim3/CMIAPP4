//
//  SettingsView.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    @State private var latestTag: String = "Loading..."
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            // 앱 설치 날짜 표시
            Text("App Created on \(getAppCreationDateString())")
                .font(.headline)
                .padding()

            // 앱 정지 경고 메시지
            if let daysRemaining = getDaysRemainingBeforeSuspension() {
                Text("App will be suspended in \(daysRemaining) days.on \(getSuspensionDateString()).")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding()
            } 
            
            Spacer()
            
            // 최신 버전 표시
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Latest Version: \(latestTag)")
                    .font(.headline)
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
        .onAppear {
                    fetchLatestTag()
            saveAppInstallationDateIfNeeded()
        }
    }
    
    func getAppCreationDateString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium

        
        // UserDefaults에 저장된 앱 생성 날짜를 불러옴
        if let savedDate = UserDefaults.standard.object(forKey: "AppCreationDate") as? Date {
            return formatter.string(from: savedDate)
        } else {
            return "Unknown"
        }
     }
    func getSuspensionDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let calendar = Calendar.current
        let currentDate = Date()
        
        // 오늘 기준으로 10일 후의 날짜 계산
        let suspensionDate = calendar.date(byAdding: .day, value: 10, to: currentDate)!
        return formatter.string(from: suspensionDate)
    }
    
    func getDaysRemainingBeforeSuspension() -> Int? {
        /*
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
         */
        let calendar = Calendar.current
        let currentDate = Date()
        
        // 오늘 기준으로 10일 후의 날짜 계산
        let suspensionDate = calendar.date(byAdding: .day, value: 10, to: currentDate)!
        
        // 오늘부터 정지일까지 남은 날 계산
        let remainingDays = calendar.dateComponents([.day], from: currentDate, to: suspensionDate).day
        return remainingDays
    }
    private func fetchLatestTag() {
            APIService.shared.fetchLatestTag { result in
                switch result {
                case .success(let tag):
                    latestTag = tag
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    private func saveAppInstallationDateIfNeeded() {
        // 최초 실행 시 앱 설치 날짜를 저장
        if UserDefaults.standard.object(forKey: "AppInstallationDate") == nil {
            let installationDate = Date()
            UserDefaults.standard.set(installationDate, forKey: "AppInstallationDate")
        }
    }
}
