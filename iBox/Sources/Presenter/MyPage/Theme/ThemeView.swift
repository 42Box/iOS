//
//  ThemeView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

import SnapKit

class ThemeView: BaseView {
    
    // MARK: - UI

    let tableView = UITableView().then {
        $0.register(ThemeCell.self, forCellReuseIdentifier: "ThemeCell")
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
    }
    
    // MARK: - BaseViewProtocol
    
    override func configureUI() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
