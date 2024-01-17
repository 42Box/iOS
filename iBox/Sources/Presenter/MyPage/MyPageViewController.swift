//
//  MyPageViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class MyPageViewController: BaseNavigationBarViewController<MyPageView> {
    
    // MARK: - properties
    
    var myPageSections: [MyPageSection] = [
        .init(title: "settings", items: [
            MyPageItem(title: "테마", viewController: ThemeViewController())
        ]),
        .init(title: "help", items: [
            MyPageItem(title: "이용 가이드"),
            MyPageItem(title: "앱 피드백"),
            MyPageItem(title: "개발자 정보", description: "지쿠 😆✌🏻")
        ])
    ]
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contentView = contentView as? MyPageView else { return }
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        contentView.profileView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("My Page")
    }
    
    // MARK: - functions
    
    @objc func profileViewTapped(_ gesture: UITapGestureRecognizer) {
        let viewController = ProfileViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 뷰의 섹션 개수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageSections.count
    }
    
    // 테이블 뷰의 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageSections[section].items.count
    }
    
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageItemCell")
                as? MyPageItemCell else { return UITableViewCell() }
        let item = myPageSections[indexPath.section].items[indexPath.row]
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
        let item = myPageSections[indexPath.section].items[indexPath.row]
        guard let viewController = item.viewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
