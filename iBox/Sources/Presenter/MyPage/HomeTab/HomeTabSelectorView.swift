//
//  HomeTabSelectorView.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Combine
import UIKit

class HomeTabSelectorView: BaseView {
    
    // MARK: - Properties
    
    private var viewModel: HomeTabSelectorViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(HomeTabSelectorCell.self, forCellReuseIdentifier: HomeTabSelectorCell.reuseIdentifier)
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
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
    
    private func setupLayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: HomeTabSelectorViewModel) {
        self.viewModel = viewModel
        viewModel.$selectedIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedIndex in
                UserDefaultsManager.homeTabIndex = selectedIndex
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
}

extension HomeTabSelectorView: UITableViewDelegate {
    
    // 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // 테이블 뷰 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectedIndex = indexPath.row
    }
    
}

extension HomeTabSelectorView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeTabType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: HomeTabSelectorCell.reuseIdentifier) as? HomeTabSelectorCell else { return UITableViewCell() }
        cell.titleLabel.text = HomeTabType.allCases[indexPath.row].toString()
        cell.setupSelectButton(viewModel.selectedIndex == indexPath.row)
        return cell
    }
    
}
