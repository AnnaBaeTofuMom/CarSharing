//
//  CarListTableViewCell.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import SnapKit

class CarListTableViewCell: UITableViewCell {

    let carImage: UIImageView = UIImageView()
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "귀여워요 아이오닉 옴팡져요"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "굉장히 귀여운 자동차입니다. 굉장히 귀여운 자동차입니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        makeConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        descLabel.text = ""
    }
    
    private func configure() {
        self.contentView.backgroundColor = .white
        
        [carImage, labelStack].forEach { self.contentView.addSubview($0) }
        
        [nameLabel, descLabel].forEach {
            self.labelStack.addArrangedSubview($0)
        }
    }
    
    private func makeConstratins() {
        carImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.width.height.equalTo(100)
        }
        
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(carImage.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(24)
        }
    }
}
