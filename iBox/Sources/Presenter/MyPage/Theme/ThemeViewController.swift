//
//  ThemeViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ThemeViewController: BaseNavigationBarViewController<ThemeView> {
    
    // MARK: - properties
    
    var selected = UserDefaultsManager.theme.value
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? ThemeView else { return }
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaultsManager.theme.value = selected
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("다크 모드 설정")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

extension ThemeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 뷰의 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Theme.allCases.count
    }
    
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell")
                as? ThemeCell else { return UITableViewCell() }
        let theme = Theme.allCases[indexPath.row]
        cell.bind(theme)
        cell.setupSelectButton(theme == selected)
        return cell
    }
    
    // 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // 테이블 뷰 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = Theme.allCases[indexPath.row]
        tableView.reloadData() // 다시 그리기
    }
    
}
