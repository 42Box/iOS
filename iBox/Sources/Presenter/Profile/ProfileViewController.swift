//
//  ProfileViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class ProfileViewController: BaseNavigationBarViewController<ProfileView> {
    
    // MARK: - properties
    
    var profileSections: [ProfileSection] = [
        .init(title: "settings", items: [
            ProfileItem(title: "다크 모드")
        ]),
        .init(title: "help", items: [
            ProfileItem(title: "이용 가이드"),
            ProfileItem(title: "앱 피드백"),
            ProfileItem(title: "개발자 정보")
        ])
    ]
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contentView = contentView as? ProfileView else { return }
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("Profile")
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 뷰의 섹션 개수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileSections.count
    }
    
    // 테이블 뷰의 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections[section].items.count
    }
    
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell")
                as? ProfileItemCell else { return UITableViewCell() }
        let profileItem = profileSections[indexPath.section].items[indexPath.row]
        cell.titleLabel.text = profileItem.title
        return cell
    }
    
    // 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 섹션 헤더의 View 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 { return nil }
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
        let profileItem = profileSections[indexPath.section].items[indexPath.row]
        guard let viewController = profileItem.viewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
