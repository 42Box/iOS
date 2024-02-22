//
//  ThemeView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import Combine
import UIKit

import SnapKit

class ThemeView: BaseView {
    
    // MARK: - Properties
    
    private var viewModel: ThemeViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI

    let tableView = UITableView().then {
        $0.register(ThemeCell.self, forCellReuseIdentifier: "ThemeCell")
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BaseViewProtocol
    
    private func setupProperties() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func configureUI() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bineViewModel(_ viewModel: ThemeViewModel) {
        self.viewModel = viewModel
        viewModel.$selectedIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedIndex in
                guard let window = self?.window else { return }
                UserDefaultsManager.theme.value = Theme.allCases[selectedIndex]
                window.overrideUserInterfaceStyle = self?.toUserInterfaceStyle(UserDefaultsManager.theme.value) ?? .unspecified
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
}

extension ThemeView: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 뷰의 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Theme.allCases.count
    }
    
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell")
                as? ThemeCell else { return UITableViewCell() }
        let theme = Theme.allCases[indexPath.row]
        cell.bind(theme)
        cell.setupSelectButton(viewModel.selectedIndex == indexPath.row)
        return cell
    }
    
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
