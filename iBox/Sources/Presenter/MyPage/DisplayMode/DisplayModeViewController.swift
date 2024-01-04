//
//  DisplayModeViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class DisplayModeViewController: BaseNavigationBarViewController<DisplayModeView> {
    
    // MARK: - properties
    
    let displayMode: [DisplayModeItem] = [
        DisplayModeItem(title: "라이트 모드", image: UIImage(systemName: "circle")),
        DisplayModeItem(title: "다크 모드", image: UIImage(systemName: "circle.fill")),
        DisplayModeItem(title: "시스템 설정 모드", image: UIImage(systemName: "circle.righthalf.filled"))
    ]
    
    var selected = 0 // 예시
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? DisplayModeView else { return }
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("다크 모드 설정")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

extension DisplayModeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 뷰의 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayMode.count
    }
    
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayModeCell")
                as? DisplayModeCell else { return UITableViewCell() }
        cell.bind(displayMode[indexPath.row])
        cell.setupSelectButton(indexPath.row == selected)
        return cell
    }
    
    // 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // 테이블 뷰 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        tableView.reloadData() // 다시 그리기
    }
    
}
