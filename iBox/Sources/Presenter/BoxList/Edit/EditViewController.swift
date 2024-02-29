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

class EditViewController: BaseBottomSheetViewController<EditView> {
    
    var delegate: BoxListViewDelegate?
    
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
