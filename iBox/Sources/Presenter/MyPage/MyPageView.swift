//
//  ProfileView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class MyPageView: BaseView {
    
    // MARK: - Properties
    
    var delegate: MyPageViewDelegate?
    private var viewModel: MyPageViewModel?
    
    // MARK: - UI
    
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
        $0.register(MyPageItemCell.self, forCellReuseIdentifier: "MyPageItemCell")
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
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    override func configureUI() {
        addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(profileLabel)
        profileView.addSubview(chevronButton)
        addSubview(tableView)
        
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
            $0.right.equalToSuperview().inset(20)
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
    }
    
    // MARK: - functions
    
    @objc func profileViewTapped() {
        delegate?.pushViewController(ProfileViewController())
    }
    
}

extension MyPageView: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 뷰의 섹션 개수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.myPageSectionViewModels.count
    }
    
    // 테이블 뷰의 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.myPageSectionViewModels[section].model.items.count
    }
    
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageItemCell")
                as? MyPageItemCell else { return UITableViewCell() }
        let item = viewModel.myPageSectionViewModels[indexPath.section].model.items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        return cell
    }
    
    // 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // 섹션 헤더의 View 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGroupedBackground
        return headerView
    }
    
    // 섹션 헤더의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // 테이블 뷰 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let item = viewModel.myPageSectionViewModels[indexPath.section].model.items[indexPath.row]
        delegate?.pushViewController(indexPath)
    }
    
}
