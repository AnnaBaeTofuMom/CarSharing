//
//  Cars.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import Foundation

enum CarCategory: String, CaseIterable, Equatable {
    case EV
    case COMPACT
    case COMPACT_SUV
    case SEMI_MID_SUV
    case SEMI_MID_SEDAN
    case MID_SUV
    case MID_SEDAN
}

extension CarCategory {
    var krName: String {
        switch self {
        case .EV:
            return "전기"
        case .COMPACT:
            return "소형"
        case .COMPACT_SUV:
            return "소형 SUV"
        case .SEMI_MID_SUV:
            return "준중형 SUV"
        case .SEMI_MID_SEDAN:
            return "준중형 세단"
        case .MID_SUV:
            return "중형 SUV"
        case .MID_SEDAN:
            return "중형 세단"
        }
    }
}

struct Cars {
    let carItems: [Car]
}

struct Car {
    let id, name, description: String?
    let imageURL: String?
    let category: CarCategory
}
