//
//  DiscoverMapUseCase.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit

import RxRelay

final class DiscoverMapUseCase {
    let mapRepository: DiscoverMapRepository
    let zoneList = PublishRelay<[Zone]>()
    let carList = PublishRelay<[Car]>()
    let error = PublishRelay<Error>()
    
    init(mapRepository: DiscoverMapRepository) {
        self.mapRepository = mapRepository
    }
    
    func requestZones() {
        mapRepository.requestZone { response in
            switch response {
            case .success(let zones):
                self.zoneList.accept(zones)
            case .failure(let error):
                self.error.accept(error)
            }
        }
    }
    
    func requestCars(id: String) {
        mapRepository.requestCars(id: id) { response in
            switch response {
            case .success(let cars):
                self.carList.accept(cars)
            case .failure(let error):
                self.error.accept(error)
            }
        }
    }
}
