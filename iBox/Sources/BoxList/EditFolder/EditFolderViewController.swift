//
//  EditFolderViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

protocol EditFolderViewControllerDelegate: AnyObject {
    func addFolder(_ folder: Folder)
}

class EditFolderViewController: BaseViewController<EditFolderView>, BaseViewControllerProtocol {
    weak var delegate: EditFolderViewControllerDelegate?
    private var folders: [Folder] {
        didSet {
            setupEditFolderView()
        }
    }
    
    init(folders: [Folder]) {
        self.folders = folders
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditFolderView()
        setupNavigationBar()
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    func setupEditFolderView() {
        guard let contentView = contentView as? EditFolderView else { return }
        let viewModel = EditFolderViewModel(folderList: folders)
        contentView.viewModel = viewModel
    }
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("폴더 관리")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarAddButtonHidden(false)
        setNavigationBarBackButtonHidden(false)
        setNavigationBarAddButtonAction(#selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        let controller = UIAlertController(title: "새로운 폴더", message: "이 폴더의 이름을 입력하십시오.", preferredStyle: .alert)
        controller.addTextField()
        controller.textFields?.first?.text = "새로운 폴더"
        controller.textFields?.first?.autocorrectionType = .no
        controller.textFields?.first?.spellCheckingType = .no
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in return }
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            guard let name = controller.textFields?.first?.text else { return }
            let folder = Folder(id: UUID(), name: name, bookmarks: [])
            self?.folders.append(folder)
            CoreDataManager.shared.addFolder(folder)
            self?.delegate?.addFolder(folder)
        }
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        self.present(controller, animated: true)
    }
}
