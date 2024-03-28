//
//  AddBookmarkViewController.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

protocol AddBookmarkViewControllerProtocol: AnyObject {
    func addFolderDirect(_ folder: Folder)
    func addBookmarkDirect(_ bookmark: Bookmark, at folderIndex: Int)
}

final class AddBookmarkViewController: UIViewController {
    weak var delegate: AddBookmarkViewControllerProtocol?
    
    var haveValidInput = false
    var selectedFolder: Folder?
    var selectedFolderIndex: Int?
    var folders = [Folder]()
    
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
        updateSelectedFolder()
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
            self?.haveValidInput = isEnabled
            
            if let haveValidInput = self?.haveValidInput,
               haveValidInput,
               let _ = self?.selectedFolder {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
        view = addBookmarkView
    }
    
    private func updateSelectedFolder() {
        let selectedFolderId = UserDefaultsManager.selectedFolderId
        
        for (index, folder) in folders.enumerated() {
            if folder.id == selectedFolderId {
                selectedFolder = folder
                selectedFolderIndex = index
            }
        }
        
        if selectedFolder == nil && !folders.isEmpty {
            selectedFolder = folders[0]
            selectedFolderIndex = 0
        }
        
        if let selectedFolder {
            addBookmarkView.selectedFolderName = selectedFolder.name
        } else {
            addBookmarkView.selectedFolderName = "선택된 폴더가 없습니다."
        }
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

        if let selectedFolder = selectedFolder,
           let selectedFolderIndex = selectedFolderIndex {
            CoreDataManager.shared.addBookmark(newBookmark, folderId: selectedFolder.id)
            delegate?.addBookmarkDirect(newBookmark, at: selectedFolderIndex)
        } else {
            print("선택된 폴더가 없습니다.")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openFolderSelection() {
        let folderListViewController = FolderListViewController(folders: folders, selectedId: selectedFolder?.id)
        folderListViewController.title = "목록"
        folderListViewController.delegate = self
        
        navigationController?.pushViewController(folderListViewController, animated: true)
    }
    
}

extension AddBookmarkViewController: FolderListViewControllerDelegate {
    func addFolder(_ folder: Folder) {
        delegate?.addFolderDirect(folder)
    }
    
    func selectFolder(_ folder: Folder, at index: Int) {
        selectedFolder = folder
        selectedFolderIndex = index
        
        if haveValidInput {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        addBookmarkView.selectedFolderName = selectedFolder?.name
    }
    
}
