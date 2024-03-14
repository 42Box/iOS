//
//  SettingsView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import Combine
import UIKit

final class SettingsView: UIView {
    
    var delegate: SettingsViewDelegate?
    private var viewModel: SettingsViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components

    let tableView = UITableView().then {
        $0.register(SettingsItemCell.self, forCellReuseIdentifier: SettingsItemCell.reuseIdentifier)
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupHierarchy() {
        addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .updateSectionViewModels:
                    self?.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - Action Functions
    
    @objc private func handleSwitchControlTap(_ controlSwitch: UISwitch) {
        guard let viewModel = viewModel else { return }
        viewModel.input.send(.setPreload(controlSwitch.isOn))
    }
    
}

extension SettingsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let settingsItem = viewModel.sectionViewModels[indexPath.section].cellViewModels[indexPath.row].settingsItem
        if (settingsItem.type != SettingsType.preload) {
            delegate?.pushViewController(settingsItem.type)
        }
    }
    
}

extension SettingsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.sectionViewModels[section].cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemCell.reuseIdentifier)
                as? SettingsItemCell else { return UITableViewCell() }
        let cellViewModel = viewModel.sectionViewModels[indexPath.section].cellViewModels[indexPath.row]
        cell.bindViewModel(cellViewModel)
        if cellViewModel.flag != nil {
            cell.switchControl.removeTarget(nil, action: nil, for: .valueChanged)
            cell.switchControl.addTarget(self, action: #selector(handleSwitchControlTap), for: .valueChanged)
        }
        return cell
    }
    
}
