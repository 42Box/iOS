//
//  BoxListViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class BoxListViewController: BaseViewController<BoxListView>, BaseViewControllerProtocol {
    
    var shouldPresentModalAutomatically: Bool = false {
        didSet {
            if shouldPresentModalAutomatically {
                // shouldPresentModalAutomatically가 true로 설정될 때 함수 호출
                dismiss(animated: false) {
                    self.addButtonTapped()
                }
                // 함수 호출 후 shouldPresentModalAutomatically를 false로 설정
                shouldPresentModalAutomatically = false
            }
        }
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.input.send(.viewDidLoad)
        contentView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.input.send(.viewWillAppear)
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("iBox")
        setNavigationBarMenuButtonHidden(false)
        setNavigationBarAddButtonAction(#selector(addButtonTapped))
        setNavigationBarMoreButtonAction(#selector(moreButtonTapped))
        setNavigationBarDoneButtonAction(#selector(doneButtonTapped))
    }
    
    // MARK: - Action Functions
    
    @objc private func addButtonTapped() {
        guard let contentView = contentView as? BoxListView else { return }
        
        let addBookmarkViewController = AddBookmarkViewController()
        addBookmarkViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addBookmarkViewController)

        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func moreButtonTapped() {
        let editViewController = EditViewController(bottomSheetHeight: 200)
        editViewController.delegate = self
        present(editViewController, animated: false)
    }
    
    @objc private func doneButtonTapped() {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.input.send(.toggleEditStatus)
        setNavigationBarMenuButtonHidden(false)
        setNavigationBarDoneButtonHidden(true)
    }

}

extension BoxListViewController: AddBookmarkViewControllerProtocol {
    func addFolderDirect(_ folder: Folder) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.addFolderDirect(folder)
    }
    
    func addBookmarkDirect(_ bookmark: Bookmark, at folderIndex: Int) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.addBookmarkDirect(bookmark, at: folderIndex)
        if UserDefaultsManager.isHaptics {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
}

extension BoxListViewController: BoxListViewDelegate {
    func presentEditBookmarkController(at indexPath: IndexPath) {
        guard let contentView = contentView as? BoxListView else { return }
        
        let controller = UIAlertController(title: "북마크 편집", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in return }
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            guard let newName = controller.textFields?.first?.text else { return }
            guard let newUrlString = controller.textFields?.last?.text,
            let newUrl = URL(string: newUrlString) else { return }
            guard let contentView = self?.contentView as? BoxListView else { return }
            
            contentView.viewModel?.editBookmark(at: indexPath, name: newName, url: newUrl)
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
        controller.addTextField() { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                        let textIsNotEmpty = textCount > 0
                        
                        okAction.isEnabled = textIsNotEmpty
                    
                })
        }
        
        guard let bookmark = contentView.viewModel?.bookmark(at: indexPath) else { return }
        
        controller.textFields?.first?.text = bookmark.name
        controller.textFields?.first?.autocorrectionType = .no
        controller.textFields?.first?.spellCheckingType = .no
        
        controller.textFields?.last?.text = bookmark.url.absoluteString
        controller.textFields?.last?.autocorrectionType = .no
        controller.textFields?.last?.spellCheckingType = .no
        
        self.present(controller, animated: true)
    }
    
    
    func didSelectWeb(id: UUID, at url: URL, withName name: String) {
        if let cachedViewController = WebCacheManager.shared.viewControllerForKey(id) {
            // 이미 캐시에 존재한다면, 그 인스턴스를 재사용
            navigationController?.pushViewController(cachedViewController, animated: true)
        } else {
            // 캐시에 없는 경우, 새로운 viewController 인스턴스를 생성하고 캐시에 추가합니다.
            let viewController = WebViewController()
            viewController.selectedWebsite = url
            viewController.title = name
            WebCacheManager.shared.cacheData(forKey: id, viewController: viewController)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func pushViewController(type: EditType) {
        guard let contentView = contentView as? BoxListView else { return }
        switch type {
        case .folder:
            
            let editFolderViewController = EditFolderViewController(folders: contentView.viewModel?.folders ?? [])
            editFolderViewController.delegate = self
            navigationController?.pushViewController(editFolderViewController, animated: true)
        case .bookmark:
            contentView.viewModel?.input.send(.toggleEditStatus)
            setNavigationBarMenuButtonHidden(true)
            setNavigationBarDoneButtonHidden(false)
        }
    }
    
    func pushViewController(url: URL?) {
        guard let url = url else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
}

extension BoxListViewController: EditFolderViewControllerDelegate {
    func moveFolder(from: Int, to: Int) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.moveFolder(from: from, to: to)
    }
    
    func editFolderName(at row: Int, name: String) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.editFolderName(at: row, name: name)
    }
    
    func deleteFolder(at row: Int) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.deleteFolder(at: row)
        if UserDefaultsManager.isHaptics {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    func addFolder(_ folder: Folder) {
        guard let contentView = contentView as? BoxListView else { return }
        contentView.viewModel?.addFolder(folder)
        if UserDefaultsManager.isHaptics {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
