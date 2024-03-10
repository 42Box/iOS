//
//  AddBookmarkViewController.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

class AddBookmarkViewController: UIViewController {
    

    override func loadView() {
        let addBookmarkView = AddBookmarkView()
        addBookmarkView.onButtonTapped = { [weak self] in
            self?.navigateToDetailScreen()  // 함수이름 수정 필요
        }
        
        // '추가' 버튼 비활성화 관련
        addBookmarkView.onTextChange = { [weak self] isEnabled in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }

        
        view = addBookmarkView
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
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        // 저장 로직을 여기에 구현
        print("저장 로직 실행")
        
        // 모달을 닫습니다.
        self.dismiss(animated: true, completion: nil)
    }
    
    private func navigateToDetailScreen() {
        let folderListViewController = FolderListViewController()
        folderListViewController.title = "목록"
        navigationController?.pushViewController(folderListViewController, animated: true)
        
        
    }
}
