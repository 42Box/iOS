//
//  EditViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

protocol EditViewDelegate {
    func pushViewController(type: EditType)
}

class EditViewController: BottomSheetViewController<EditView> {
    
    var delegate: BoxListViewDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetView.delegate = self
    }
    
}

extension EditViewController: EditViewDelegate {
    
    func pushViewController(type: EditType) {
        delegate?.pushViewController(type: type)
        dismiss(animated: false)
    }
    
}
