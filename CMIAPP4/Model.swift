//
//  Model.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

import Foundation

// Define the SalesResponse struct to decode the API response
struct SalesResponse: Codable {
    let totalPrice: Double
    let totalCreditPrice: Double
}

// Define the PaymentTypeCounts struct to decode the API response for room rent status
struct PaymentTypeCounts: Codable {
    let da: Int
    let wk: Int
    let mo: Int
    let wc: Int
    let ml: Int
}

// Define the TodayCheckInOutResponse struct to decode the API response for today's check-ins and check-outs
struct TodayCheckInOutResponse: Codable {
    let todayCheckIns: Int
    let todayCheckOuts: Int
}

struct RoomOccupancyResponse: Decodable {
    let totalRooms: Int
    let availableRooms: Int
}

