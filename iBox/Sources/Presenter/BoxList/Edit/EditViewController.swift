//
//  EditViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

protocol EditViewDelegate {
    func pushViewController(index: Int)
}

class EditViewController: BaseBottomSheetViewController<EditView> {
    
    var delegate: BoxListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetView.delegate = self
    }
    
}

extension EditViewController: EditViewDelegate {
    
    func pushViewController(index: Int) {
        delegate?.pushViewController(index: index)
        dismiss(animated: false)
    }
    
}
