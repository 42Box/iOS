//
//  FolderListViewController.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

protocol FolderListViewControllerDelegate: AnyObject {
    func selectFolder(_ folder: Folder, at index: Int)
    func addFolder(_ folder: Folder)
}

class FolderListViewController: UIViewController {
    weak var delegate: FolderListViewControllerDelegate?
    
    let folderListView = FolderListView()
    
    init(folders: [Folder], selectedId: UUID?) {
        super.init(nibName: nil, bundle: nil)
        setupFolderListView(folders, selectedId: selectedId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = folderListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addFolder() {
        let controller = UIAlertController(title: "새로운 폴더", message: "이 폴더의 이름을 입력하십시오.", preferredStyle: .alert)
        
        controller.addTextField { textField in
            textField.placeholder = "폴더 이름"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "추가", style: .default) { [unowned controller, weak self] _ in
            guard let textField = controller.textFields?.first,
                  let folderName = textField.text, !folderName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            let newFolder = Folder(id: UUID(), name: folderName, bookmarks: [])
            CoreDataManager.shared.addFolder(newFolder)
            self?.folderListView.folders.append(newFolder)
            
            self?.folderListView.selectedFolderId = newFolder.id
            UserDefaultsManager.selectedFolderId = newFolder.id
            
            self?.folderListView.reloadFolderList()
            self?.delegate?.addFolder(newFolder)
        }
        
        controller.addAction(cancelAction)
        controller.addAction(addAction)
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: controller.textFields?.first, queue: .main) { notification in
            if let textField = notification.object as? UITextField,
               let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                addAction.isEnabled = true
            } else {
                addAction.isEnabled = false
            }
        }
        
        addAction.isEnabled = false
        
        present(controller, animated: true)
    }
    
    private func setupFolderListView(_ folders: [Folder], selectedId: UUID?) {
        folderListView.delegate = self
        folderListView.folders = folders
        folderListView.selectedFolderId = selectedId
    }
}

extension FolderListViewController: FolderListViewDelegate {
    func selectFolder(_ folder: Folder, at index: Int) {
        delegate?.selectFolder(folder, at: index)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FolderListViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
