//
//  BoxListCell.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import UIKit

import SnapKit

class BoxListCell: UITableViewCell {
    var viewModel: BoxListCellViewModel?
    static let reuseIdentifier = "boxListCell"
    
    private lazy var cellImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "ellipsis.rectangle.fill")
        view.tintColor = .label
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var label = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewBackgroundColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(30)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(cellImageView.snp.trailing).offset(10)
        }
    }
    
    func configure(_ viewModel: BoxListCellViewModel) {
        self.viewModel = viewModel
        label.text = viewModel.name
    }

}
