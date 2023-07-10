//
//  FavoriteListHeaderView.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import SnapKit

final class FavoriteListHeaderView: UIView {

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "쏘카존 즐겨찾기"
        label.font = .systemFont(ofSize: 24, weight: UIFont.Weight(600))
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [nameLabel].forEach { self.addSubview($0) }
        self.backgroundColor = .white
        makeConstraints()
    }
    
    private func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

