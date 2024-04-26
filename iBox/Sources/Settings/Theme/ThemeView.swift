//
//  ThemeView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import Combine
import UIKit

import SnapKit

class ThemeView: UIView {
    
    private var viewModel: ThemeViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components

    let tableView = UITableView().then {
        $0.register(ThemeCell.self, forCellReuseIdentifier: ThemeCell.reuseIdentifier)
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
    
    func bineViewModel(_ viewModel: ThemeViewModel) {
        self.viewModel = viewModel
        viewModel.$selectedIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedIndex in
                guard let window = self?.window else { return }
                UserDefaultsManager.theme = Theme.allCases[selectedIndex]
                window.overrideUserInterfaceStyle = self?.toUserInterfaceStyle(UserDefaultsManager.theme) ?? .unspecified
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
}

extension ThemeView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectedIndex = indexPath.row
    }
    
}

extension ThemeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Theme.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.reuseIdentifier)
                as? ThemeCell else { return UITableViewCell() }
        let theme = Theme.allCases[indexPath.row]
        cell.bind(theme)
        cell.setupSelectButton(viewModel.selectedIndex == indexPath.row)
        return cell
    }
    
}
