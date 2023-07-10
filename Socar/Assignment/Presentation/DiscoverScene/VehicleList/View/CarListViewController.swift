//
//  VehicleListViewController.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class CarListViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    private var viewModel: CarListViewModel!
    
    let headerView = CarListHeaderView()
    
    let sectionHeader = CarListHeaderView()
    
    let tableView = UITableView()
    
    init(viewModel: CarListViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
        makeConstraints()
    }
    
    private func bind() {
        headerView.rx.bindZone().onNext(viewModel.zone.value)
        
        viewModel.isFavorite
            .withUnretained(self)
            .subscribe { owner, isFavorite in
                if isFavorite {
                    owner.headerView
                        .favoriteButton
                        .setImage(UIImage(named: "_ic24_favorite_blue"), for: .normal)
                } else {
                    owner.headerView
                        .favoriteButton
                        .setImage(UIImage(named: "_ic24_favorite_gray"), for: .normal)
                }
            }.disposed(by: disposeBag)
        
        headerView.favoriteButton
            .rx
            .tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.viewModel.favoriteAction.accept(())
            }.disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<CarListSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CarList", for: indexPath) as! CarListTableViewCell
                cell.nameLabel.text = item.name
                cell.descLabel.text = item.description
                let url = URL(string: item.imageURL ?? "")!
                cell.carImage.kf.setImage(with: url)
                return cell
            })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewModel.sectionedDataSource.map { sections -> [CarListSectionModel] in
            return sections.filter { $0.items.count > 0 }
        }.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        [headerView, tableView].forEach { view.addSubview($0) }
        
        tableView.register(CarListTableViewCell.self, forCellReuseIdentifier: "CarList")
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(64)
        }
    }
}

extension Reactive where Base: CarListHeaderView {
    func bindZone() -> Binder<Zone> {
        return Binder(self.base) { header, zone in
            header.nameLabel.text = zone.name
            header.aliasLabel.text = zone.alias
        }
    }
}
