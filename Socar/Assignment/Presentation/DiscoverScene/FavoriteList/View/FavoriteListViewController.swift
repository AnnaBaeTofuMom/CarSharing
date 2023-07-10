//
//  StarredListViewController.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class FavoriteListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic24_close"), for: .normal)
        return button
    }()
    
    let headerView = FavoriteListHeaderView()
    
    let viewModel: FavoriteListViewModel
    
    let tableView = UITableView()
    
    init(viewModel: FavoriteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        configure()
        makeConstraints()
    }
    
    private func bind() {
        
        closeButton.rx.tap.withUnretained(self).subscribe { owner, _ in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.favoriteList
            .bind(to: tableView.rx.items) { tableView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteList", for: indexPath) as! FavoriteListTableViewCell
                cell.nameLabel.text = element.name
                cell.descLabel.text = element.alias
                cell.selectionStyle = .none
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.withUnretained(self).subscribe { owner, indexPath in
            let zone = owner.viewModel.favoriteList.value[indexPath.row]
            let viewModel = owner.viewModel.factory.makeCarListViewModel(zone: zone)
            self.dismiss(animated: true) {
                Router.shared.actions.accept(.toCarList(viewModel: viewModel))
            }
        }.disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        [closeButton, tableView, headerView].forEach { view.addSubview($0) }
        tableView.register(FavoriteListTableViewCell.self, forCellReuseIdentifier: "FavoriteList")
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
    }
    
    private func makeConstraints() {
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(24)
        }

        headerView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    

}
