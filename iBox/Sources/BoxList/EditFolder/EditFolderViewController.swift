//
//  EditFolderViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

protocol EditFolderViewControllerDelegate: AnyObject {
    func addFolder(_ folder: Folder)
    func deleteFolder(at row: Int)
    func editFolderName(at row: Int, name: String)
    func moveFolder(from: Int, to: Int)
}

class EditFolderViewController: BaseViewController<EditFolderView>, BaseViewControllerProtocol {
    weak var delegate: EditFolderViewControllerDelegate?
    
    init(folders: [Folder]) {
        super.init(nibName: nil, bundle: nil)
        setupEditFolderView(folders)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    func setupEditFolderView(_ folders: [Folder]) {
        guard let contentView = contentView as? EditFolderView else { return }
        let viewModel = EditFolderViewModel(folderList: folders)
        contentView.viewModel = viewModel
        contentView.delegate = self
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
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in return }
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            guard let name = controller.textFields?.first?.text else { return }
            let folder = Folder(id: UUID(), name: name, bookmarks: [])
            guard let contentView = self?.contentView as? EditFolderView else { return }
            contentView.viewModel?.addFolder(folder)
            self?.delegate?.addFolder(folder)
        }
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        okAction.isEnabled = false
        
        controller.addTextField() { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                        let textIsNotEmpty = textCount > 0
                        
                        okAction.isEnabled = textIsNotEmpty
                    
                })
        }
        controller.textFields?.first?.placeholder = "이름"
        controller.textFields?.first?.autocorrectionType = .no
        controller.textFields?.first?.spellCheckingType = .no
        self.present(controller, animated: true)
    }
    
}

extension EditFolderViewController: EditFolderViewDelegate {
    func moveFolder(from: Int, to: Int) {
        delegate?.moveFolder(from: from, to: to)
    }
    
    func deleteFolder(at indexPath: IndexPath) {
        recheckDeleteFolder(at: indexPath)
    }
    
    private func recheckDeleteFolder(at indexPath: IndexPath) {
        let actionSheetController = UIAlertController(title: nil, message: "모든 북마크가 삭제됩니다.", preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "폴더 삭제", style: .destructive) {[weak self] _ in
            guard let contentView = self?.contentView as? EditFolderView else { return }
            contentView.viewModel?.deleteFolder(at: indexPath)
            self?.delegate?.deleteFolder(at: indexPath.row)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true)
    }
    
    func editFolderName(at indexPath: IndexPath, name: String) {
        let controller = UIAlertController(title: "폴더 이름 변경", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in return }
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            guard let newName = controller.textFields?.first?.text else { return }
            guard let contentView = self?.contentView as? EditFolderView else { return }
            contentView.viewModel?.editFolderName(at: indexPath, name: newName)
            self?.delegate?.editFolderName(at: indexPath.row, name: newName)
        }
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        okAction.isEnabled = true
        
        controller.addTextField() { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                        let textIsNotEmpty = textCount > 0
                        
                        okAction.isEnabled = textIsNotEmpty
                    
                })
        }
        controller.textFields?.first?.text = name
        controller.textFields?.first?.autocorrectionType = .no
        controller.textFields?.first?.spellCheckingType = .no
        
        self.present(controller, animated: true)
    }
    
}
