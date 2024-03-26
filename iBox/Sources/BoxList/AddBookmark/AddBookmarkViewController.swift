//
//  AddBookmarkViewController.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

final class AddBookmarkViewController: UIViewController {
    
    var selectedFolder: Folder?
    private let coreDataManager = CoreDataManager.shared
    private let addBookmarkView = AddBookmarkView()


    override func loadView() {
        super.loadView()
        setupAddBookmarkView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelectedFolder()
        addBookmarkView.updateTextFieldsFilledState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.tintColor = .box
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "새로운 북마크"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semiboldLabelFont
        ]

        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setupAddBookmarkView() {
        addBookmarkView.onButtonTapped = { [weak self] in
            self?.openFolderSelection()
        }
        addBookmarkView.onTextChange = { [weak self] isEnabled in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
        view = addBookmarkView
    }
    
    private func updateSelectedFolder() {
        selectedFolder = UserDefaultsManager.selectedFolder
        
        if selectedFolder?.name == "" {
            selectedFolder = CoreDataManager.shared.getFolders().first
        }
        
        addBookmarkView.selectedFolderName = selectedFolder?.name
    }
    
    @objc private func cancelButtonTapped() {
        
        let isTextFieldsEmpty = addBookmarkView.nameTextView.text?.isEmpty ?? true && addBookmarkView.urlTextView.text?.isEmpty ?? true

        if isTextFieldsEmpty {
            self.dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: nil, message: "변경사항 폐기", preferredStyle: .alert)


            let discardAction = UIAlertAction(title: "예", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }

            let cancelAction = UIAlertAction(title: "아니오", style: .cancel)

            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func addButtonTapped() {
        guard let name = addBookmarkView.nameTextView.text, !name.isEmpty,
              let urlString = addBookmarkView.urlTextView.text, !urlString.isEmpty,
              let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            print("Invalid input")
            return
        }

        let newBookmark = Bookmark(id: UUID(), name: name, url: url)

        if let selectedFolder = selectedFolder {
            coreDataManager.addBookmark(newBookmark, folderId: selectedFolder.id)
            print("북마크 저장 완료: \(newBookmark.name)")
        } else {
            print("선택된 폴더가 없습니다.")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openFolderSelection() {
        let folderListViewController = FolderListViewController()
        folderListViewController.title = "목록"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolderAction))
        folderListViewController.navigationItem.rightBarButtonItem = addButton
        
        navigationController?.pushViewController(folderListViewController, animated: true)
    }
    
    @objc func addFolderAction() {
        let controller = UIAlertController(title: "새로운 폴더", message: "이 폴더의 이름을 입력하십시오.", preferredStyle: .alert)
        
        controller.addTextField { textField in
            textField.placeholder = "폴더 이름"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "추가", style: .default) { [unowned controller, weak self] _ in
            guard let textField = controller.textFields?.first,
                  let folderName = textField.text, !folderName.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            let newFolder = Folder(id: UUID(), name: folderName, bookmarks: [])
            self?.coreDataManager.addFolder(newFolder)
            
            self?.updateFolderList()
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

    func updateFolderList() {
        if let folderListVC = navigationController?.viewControllers.first(where: { $0 is FolderListViewController }) as? FolderListViewController {
            folderListVC.folderListView.reloadFolderList()
        }
    }
}
