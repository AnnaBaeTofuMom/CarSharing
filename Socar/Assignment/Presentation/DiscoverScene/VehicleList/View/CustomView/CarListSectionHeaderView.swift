//
//  CarListSectionHeaderView.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import SnapKit

final class CarListSectionHeaderView: UIView {

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "섹션1"
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight(600))
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [nameLabel].forEach { self.addSubview($0) }
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
}

