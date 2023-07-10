//
//  CarListViewModel.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

final class CarListViewModel {
    
    let factory: DependencyFactory
    
    let useCase: DiscoverMapUseCase
    
    var zone: BehaviorRelay<Zone>
    
    var carList = BehaviorRelay<[Car]>(value: [])
    
    var isFavorite = BehaviorRelay<Bool>(value: false)
    
    var favoriteAction = PublishRelay<Void>()
    
    var sectionedDataSource = BehaviorRelay<[CarListSectionModel]>(value: [])
    
    var disposeBag = DisposeBag()
    
    init(factory: DependencyFactory, zone: Zone) {
        self.factory = factory
        self.useCase = factory.makeDiscoverMapUseCase()
        self.zone = BehaviorRelay<Zone>(value: zone)
        
        bind()
        requestVehicleList()
        checkIsFavorite()
        requestVehicleList()
    }
    
    private func bind() {
        
        useCase.carList
            .bind(to: carList)
            .disposed(by: disposeBag)
        
        favoriteAction.withUnretained(self).subscribe { owner, _ in
            if owner.isFavorite.value {
                owner.unfavoriteZone()
            } else {
                owner.favoriteZone()
            }
        }.disposed(by: disposeBag)
        
        carList.withUnretained(self).subscribe { owner, carList in
            owner.makeSectionModel()
        }.disposed(by: disposeBag)
    }
    
    private func requestVehicleList() {
        useCase.requestCars(id: zone.value.id)
    }
    
    private func checkIsFavorite() {
        let key = UserDefaultKey.favoriteZone.rawValue
        let id = self.zone.value.id
        let dict = UserDefaults.standard.dictionary(forKey: key)
        
        if dict?[id] == nil {
            isFavorite.accept(false)
        } else {
            isFavorite.accept(true)
        }
    }
    
    private func unfavoriteZone() {
        let key = UserDefaultKey.favoriteZone.rawValue
        let id = self.zone.value.id
        var dict = UserDefaults.standard.dictionary(forKey: key)
        dict?[id] = nil
        UserDefaults.standard.set(dict, forKey: key)
        self.isFavorite.accept(false)
    }
    
    private func favoriteZone() {
        let key = UserDefaultKey.favoriteZone.rawValue
        let id = self.zone.value.id
        var dict = UserDefaults.standard.dictionary(forKey: key)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(zone.value)
            if dict == nil {
                var new: [String: Data] = [:]
                new[id] = data
                UserDefaults.standard.set(new, forKey: key)
            } else {
                dict?[id] = data
                UserDefaults.standard.set(dict, forKey: key)
            }
            
            self.isFavorite.accept(true)
        } catch {
            print("Error encoding zones: \(error)")
        }
    }
    
    private func makeSectionModel() {
        var sections: [CarListSectionModel] = []
        CarCategory.allCases.forEach { category in
            var sectionModel = CarListSectionModel(header: category.krName, items: [])
            sections.append(sectionModel)
        }
        
        for item in self.carList.value {
            switch item.category {
            case .EV:
                sections[0].items.append(item)
            case .COMPACT:
                sections[1].items.append(item)
            case .COMPACT_SUV:
                sections[2].items.append(item)
            case .SEMI_MID_SUV:
                sections[3].items.append(item)
            case .SEMI_MID_SEDAN:
                sections[4].items.append(item)
            case .MID_SUV:
                sections[5].items.append(item)
            case .MID_SEDAN:
                sections[6].items.append(item)
            }
        }
        
        self.sectionedDataSource.accept(sections)
    }
}
