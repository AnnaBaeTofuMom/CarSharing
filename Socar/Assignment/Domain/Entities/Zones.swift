//
//  Zones.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import Foundation
import CoreLocation

// MARK: - Zone
struct Zone: Codable {
    let id, name, alias: String
    let lat, lng: Double
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case alias
            case lat
            case lng
        }
}
