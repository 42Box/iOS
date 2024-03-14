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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "새로운 북마크"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false    // 처음에 '추가' 버튼 비활성화
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
        selectedFolder = selectedFolder ?? CoreDataManager.shared.getFolders().first
        addBookmarkView.selectedFolderName = selectedFolder?.name
    }
    
    @objc private func cancelButtonTapped() {
        
        // nameTextView와 urlTextView가 모두 비어 있는지 확인
        let isTextFieldsEmpty = addBookmarkView.nameTextView.text?.isEmpty ?? true && addBookmarkView.urlTextView.text?.isEmpty ?? true

        if isTextFieldsEmpty {
            // 모든 텍스트 필드가 비어있으면, 바로 dismiss
            self.dismiss(animated: true, completion: nil)
        } else {
            // 하나라도 텍스트 필드에 내용이 있으면, 사용자에게 경고 창 표시
            let alertController = UIAlertController(title: nil, message: "취소하시겠습니까?", preferredStyle: .alert)


            let discardAction = UIAlertAction(title: "변경사항 폐기", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }

            let cancelAction = UIAlertAction(title: "취소", style: .cancel)

            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func addButtonTapped() {
        // 북마크 추가 로직
        
        guard let name = addBookmarkView.nameTextView.text, !name.isEmpty,
              let urlString = addBookmarkView.urlTextView.text, !urlString.isEmpty,
              let url = URL(string: urlString) else {
            print("Invalid input")
            return
        }

        let newBookmark = Bookmark(id: UUID(), name: name, url: url)

        // 선택된 폴더가 있을 경우에만 북마크를 추가
        if let selectedFolder = selectedFolder {
            coreDataManager.addBookmark(newBookmark, folderId: selectedFolder.id)
            print("북마크 저장 완료: \(newBookmark.name)")
        } else {
            print("선택된 폴더가 없습니다.")
        }
        
        // 모달을 닫습니다.
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openFolderSelection() {
        let folderListViewController = FolderListViewController()
        folderListViewController.title = "목록"
        navigationController?.pushViewController(folderListViewController, animated: true)
    }
    
}
