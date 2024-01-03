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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell")
                as? ProfileItemCell else { return UITableViewCell() }
        let item = profileSections[indexPath.section].items[indexPath.row]
        cell.titleLabel.text = item.title
        print("item.title : \(item.title)")
        return cell
    }
    
}
