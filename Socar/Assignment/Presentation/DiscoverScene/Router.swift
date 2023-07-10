//
//  Router.swift
//  Assignment
//
//  Created by 경원이 on 2023/06/30.
//

import UIKit

import RxSwift
import RxRelay

enum RouterAction {
    case toCarList(viewModel: CarListViewModel)
    case toFavoriteList(viewModel: FavoriteListViewModel)
}

final class Router {
    static let shared = Router()
    
    let disposeBag = DisposeBag()
    
    let actions = PublishRelay<RouterAction>()
    
    var nav: UINavigationController?
    
    private init() {
        bind()
    }
    
    func makeRootMapViewController(viewModel: DiscoverMapViewModel) -> UINavigationController {
        self.nav = UINavigationController(rootViewController: DiscoverMapViewController(viewModel: viewModel))
        return nav!
    }
    
    private func showFavoriteList(viewModel: FavoriteListViewModel) {
        let vc = FavoriteListViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        nav?.present(vc, animated: true)
    }
    
    private func showCarList(viewModel: CarListViewModel) {
        let viewModel = viewModel
        let vc = CarListViewController(viewModel: viewModel)
        nav?.pushViewController(vc, animated: true)
    }
    
    private func bind() {
        actions.withUnretained(self).subscribe { owner, action in
            switch action {
            case .toCarList(let viewModel):
                owner.showCarList(viewModel: viewModel)
            case .toFavoriteList(let viewModel):
                owner.showFavoriteList(viewModel: viewModel)
            }
        }.disposed(by: disposeBag)
    }
}
