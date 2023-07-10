//
//  FavoriteListViewModel.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import RxRelay

final class FavoriteListViewModel {
    let favoriteList = BehaviorRelay<[Zone]>(value: [])
    
    let factory: DependencyFactory
    
    init(factory: DependencyFactory) {
        self.factory = factory
        
        retrieveFavoritesFromUserDefaults()
    }
    
    private func retrieveFavoritesFromUserDefaults() {
        let list = UserDefaults.standard.dictionary(forKey: UserDefaultKey.favoriteZone.rawValue)
        
        var array: [Zone] = []
        guard let dict = list else { return }
        for item in dict {
            do {
                let decodedData = try JSONDecoder().decode(Zone.self, from: item.value as! Data)
                array.append(decodedData)
            } catch {
                
            }
        }
        
        self.favoriteList.accept(array)
    }
}
