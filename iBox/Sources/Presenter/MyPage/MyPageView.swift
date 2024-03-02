//
//  ProfileView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import Combine
import UIKit

final class MyPageView: BaseView {
    
    var delegate: MyPageViewDelegate?
    private var viewModel: MyPageViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    let profileView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle")
        $0.tintColor = .box2
    }
    
    let profileLabel = UILabel().then {
        $0.text = "예시입니당"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    let chevronButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(systemName: "chevron.right")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 10, weight: .bold)
        $0.tintColor = .systemGray3
    }

    let tableView = UITableView().then {
        $0.register(MyPageItemCell.self, forCellReuseIdentifier: MyPageItemCell.reuseIdentifier)
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
        
        profileView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileViewTapped)
            )
        )
    }
    
    private func setupHierarchy() {
        addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(profileLabel)
        profileView.addSubview(chevronButton)
        addSubview(tableView)
    }
    
    private func setupLayout() {
        profileView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        profileLabel.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        chevronButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(10)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: MyPageViewModel) {
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
    
    @objc private func profileViewTapped() {
        delegate?.pushViewController(ProfileViewController())
    }
    
    @objc private func handleSwitchControlTap(_ controlSwitch: UISwitch) {
        guard let viewModel = viewModel else { return }
        viewModel.input.send(.setPreload(controlSwitch.isOn))
    }
    
}

extension MyPageView: UITableViewDelegate {
    
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
        let myPageItem = viewModel.sectionViewModels[indexPath.section].cellViewModels[indexPath.row].myPageItem
        if (myPageItem.type != MyPageType.preload) {
            delegate?.pushViewController(myPageItem.type)
        }
    }
    
}

extension MyPageView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.sectionViewModels[section].cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: MyPageItemCell.reuseIdentifier)
                as? MyPageItemCell else { return UITableViewCell() }
        let cellViewModel = viewModel.sectionViewModels[indexPath.section].cellViewModels[indexPath.row]
        cell.bindViewModel(cellViewModel)
        if cellViewModel.flag != nil {
            cell.switchControl.removeTarget(nil, action: nil, for: .valueChanged)
            cell.switchControl.addTarget(self, action: #selector(handleSwitchControlTap), for: .valueChanged)
        }
        return cell
    }
    
}
