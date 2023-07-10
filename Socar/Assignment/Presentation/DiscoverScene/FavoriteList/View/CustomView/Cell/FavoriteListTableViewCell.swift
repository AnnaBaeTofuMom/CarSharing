//
//  FavoriteListTableViewCell.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import UIKit

import SnapKit

class FavoriteListTableViewCell: UITableViewCell {

    let annoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_zone_shadow")
        return imageView
    }()
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "우리집 앞마당 30m"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "여기는 내집이다 후후"
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
        [annoImage, labelStack].forEach { self.contentView.addSubview($0) }
        
        [nameLabel, descLabel].forEach {
            self.labelStack.addArrangedSubview($0)
        }
    }
    
    private func makeConstratins() {
        annoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(36)
            make.height.equalTo(47)
        }
        
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(annoImage.snp.trailing).offset(20)
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(24)
        }
    }
}
