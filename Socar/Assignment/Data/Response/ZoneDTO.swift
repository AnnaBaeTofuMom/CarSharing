//
//  ZonesDTO.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import Foundation
import CoreLocation

// MARK: - Zone

struct ZoneDTO: Codable {
    let id, name, alias: String
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

typealias ZonesDTO = [ZoneDTO]

extension ZonesDTO {
    func toDomain() -> [Zone] {
            return self.map { $0.toDomain() }
        }
}

extension ZoneDTO {
    func toDomain() -> Zone {
        return Zone(id: id, name: name, alias: alias, lat: location.lat, lng: location.lng)
    }
}

