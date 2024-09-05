//
//  Revenue.swift
//  CMIAPP4
//
//  Created by JC Kim on 9/2/24.
//

import Foundation

import Foundation

struct Revenue: Codable, Identifiable {
    let id = UUID() // 만약 고유 ID가 필요 없다면 이 줄을 제거하세요.
    //var id: UUID = UUID() // 초기화 없이 기본값을 제공
    let month: Int
    let cashRevenue: Decimal
    let creditRevenue: Decimal
    let totalRevenue: Decimal
}
