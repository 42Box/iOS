//
//  EditFolderView.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

protocol EditFolderViewDelegate: AnyObject {
    func deleteFolder(at: IndexPath)
    func editFolderName(at: IndexPath, name: String)
    func moveFolder(from: Int, to: Int)
}

class EditFolderView: UIView {
    weak var delegate: EditFolderViewDelegate?
    
    var viewModel: EditFolderViewModel? {
        didSet {
            viewModel?.delegate = self
            tableView.reloadData()
        }
    }
    
    private let backgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .tableViewBackgroundColor
    }
    
    private let tableView = UITableView().then {
        $0.register(EditFolderCell.self, forCellReuseIdentifier: EditFolderCell.reuserIdentifier)
        
        $0.setEditing(true, animated: true)
        $0.backgroundColor = .clear
        $0.rowHeight = 50
        $0.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
    }
    
    private func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(tableView)
    }
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
}

extension EditFolderView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.folderCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { fatalError() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditFolderCell.reuserIdentifier, for: indexPath) as? EditFolderCell else { fatalError() }
        cell.onDelete = { [weak self] in
            guard let self else { return }
            if let currentIndexPath = self.tableView.indexPath(for: cell) {
                self.delegate?.deleteFolder(at: currentIndexPath)
            }
        }
        cell.onEdit = { [weak self] in
            guard let self else { return }
            if let currentIndexPath = self.tableView.indexPath(for: cell) {
                self.editFolderName(at: currentIndexPath)
            }
        }
        cell.configure(viewModel.folderName(at: indexPath))
        return cell
    }
    
    private func editFolderName(at indexPath: IndexPath) {
        guard let viewModel else { return }
        delegate?.editFolderName(at: indexPath, name: viewModel.folderName(at: indexPath))
    }
    
}

extension EditFolderView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let viewModel else { return }
        viewModel.reorderFolder(srcIndexPath: sourceIndexPath, destIndexPath: destinationIndexPath)
        delegate?.moveFolder(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension EditFolderView: EditFolderViewModelDelegate {
    func reloadRow(_ indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func deleteRow(_ indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func addRow() {
        guard let viewModel else { return }
        let indexPath = IndexPath(row: viewModel.folderCount - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

