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
    
    // MARK: - UI Components
    
    private let cellImageView =  UIImageView().then {
        $0.image = UIImage(systemName: "ellipsis.rectangle.fill")
        $0.tintColor = .label
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .tableViewBackgroundColor
    }
    
    private func setupHierarchy() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(label)
    }
    
    private func setupLayout() {
        cellImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(30)
        }
        
        label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(cellImageView.snp.trailing).offset(10)
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: BoxListCellViewModel) {
        self.viewModel = viewModel
        label.text = viewModel.name
    }

}
