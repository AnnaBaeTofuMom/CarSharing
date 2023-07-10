//
//  CarsDTO.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import Foundation

// MARK: - Car
struct CarDTO: Codable {
    let id, name, description: String
    let imageURL: String
    let category: String
    let zones: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "imageUrl"
        case category, zones
    }
}

typealias CarsDTO = [CarDTO]


extension CarsDTO {
    func toDomain() -> [Car] {
        return self.map { $0.toDomain() }
        }
}

extension CarDTO {
    func toDomain() -> Car {
        return Car(id: id,
                   name: name,
                   description: description,
                   imageURL: imageURL,
                   category: CarCategory(rawValue: category)!
        )
    }
}
