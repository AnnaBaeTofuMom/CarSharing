//
//  DiscoverSceneDependency.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit

final class DependencyFactory {
    
    init() {
    }
    
    func makeDiscoverMapUseCase() -> DiscoverMapUseCase {
        return DiscoverMapUseCase(mapRepository: DiscoverMapRepository())
    }
    
    func makeDiscoverMapViewModel() -> DiscoverMapViewModel {
        return DiscoverMapViewModel(factory: self)
    }
    
    func makeCarListViewModel(zone: Zone) -> CarListViewModel {
        return CarListViewModel(factory: self, zone: zone)
    }
    
    func makeFavoriteListViewModel() -> FavoriteListViewModel {
        return FavoriteListViewModel(factory: self)
    }
}
