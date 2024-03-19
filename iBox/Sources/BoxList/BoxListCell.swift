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
    
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    
    // MARK: - UI Components
    
    private let cellImageView =  UIImageView().then {
        $0.image = UIImage(systemName: "ellipsis.rectangle.fill")
        $0.tintColor = .label
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel()
    
    private let editButton = UIButton().then{
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(systemName: "ellipsis.circle")?.withTintColor(.box, renderingMode: .alwaysOriginal)
        
        $0.showsMenuAsPrimaryAction = true
        $0.isHidden = true
    }
    
    private lazy var editAction = UIAction(title: "북마크 편집", image: UIImage(systemName: "pencil")) {[weak self] _ in
        self?.onEdit?()
    }
    
    private lazy var deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
        self?.onDelete?()
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperty()
        setupHierarchy()
        setupLayout()
        configureEditMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        viewModel = nil
        onDelete = nil
        onEdit = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .tableViewBackgroundColor
        selectionStyle = .none
    }
    
    private func setupHierarchy() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(label)
        contentView.addSubview(editButton)
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
        editButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func configureEditMenu() {
        editButton.menu = UIMenu(options: .displayInline, children: [editAction, deleteAction])
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: BoxListCellViewModel) {
        self.viewModel = viewModel
        label.text = viewModel.name
    }
    
    func setEditButtonHidden(_ isHidden: Bool) {
        editButton.isHidden = isHidden
    }

}
