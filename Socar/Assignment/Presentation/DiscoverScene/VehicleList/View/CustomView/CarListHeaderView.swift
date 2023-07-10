//
//  CarH.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import SnapKit

final class CarListHeaderView: UIView {
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "아크로서울포레스트타워 D타워"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let aliasLabel: UILabel = {
        let label = UILabel()
        label.text = "아크로서울포레스트타워 D타워"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "_ic24_favorite_gray"), for: .normal)
        return button
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
        [nameLabel, aliasLabel].forEach { labelStack.addArrangedSubview($0) }
        [labelStack, favoriteButton].forEach { self.addSubview($0) }
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        labelStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(5)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview().inset(23)
        }
    }
}
