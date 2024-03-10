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
        addBookmarkView.onButtonTapped = { [weak self] in
            self?.navigateToFolderListView()  // 함수이름 수정 필요
        }
        
        // '추가' 버튼 비활성화 관련
        addBookmarkView.onTextChange = { [weak self] isEnabled in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }

        view = addBookmarkView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // selectedFolder가 nil이면 CoreDataManager에서 폴더 목록을 가져와 첫 번째 요소로 초기화합니다.
        if let selectedFolder = selectedFolder {
            addBookmarkView.selectedFolderName = selectedFolder.name
        } else {
            let folders = CoreDataManager.shared.getFolders()
            if let firstFolder = folders.first {
                selectedFolder = firstFolder
                addBookmarkView.selectedFolderName = firstFolder.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        navigationItem.rightBarButtonItem?.isEnabled = false    // 처음에 비활성화
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "새로운 북마크"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(saveButtonTapped))

    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        // 저장 로직을 여기에 구현
        print("저장 로직 실행")
        
        guard let name = addBookmarkView.nameTextView.text, !name.isEmpty,
              let urlString = addBookmarkView.urlTextView.text, !urlString.isEmpty,
              let url = URL(string: urlString) else {
            print("Invalid input")
            return
        }

        let newBookmark = Bookmark(id: UUID(), name: name, url: url)

        // 선택된 폴더가 있을 경우에만 북마크를 추가합니다.
        if let selectedFolder = selectedFolder {
            coreDataManager.addBookmark(newBookmark, folderId: selectedFolder.id)
            print("북마크 저장 완료: \(newBookmark.name)")
        } else {
            print("선택된 폴더가 없습니다.")
        }
        
        
        // 모달을 닫습니다.
        self.dismiss(animated: true, completion: nil)
    }
    
    private func navigateToFolderListView() {
        let folderListViewController = FolderListViewController()
        folderListViewController.title = "목록"
        navigationController?.pushViewController(folderListViewController, animated: true)
        
        
    }
}
