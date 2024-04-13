//
//  AddBookmarkViewController.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

import SwiftSoup

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
    
    let addBookmarkView = AddBookmarkView()

    override func loadView() {
        super.loadView()
        setupAddBookmarkView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelectedFolder()
        addBookmarkView.updateTextFieldsFilledState()
        addBookmarkView.nameTextView.becomeFirstResponder()
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
        folders = CoreDataManager.shared.getFolders()
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
    
    private func fetchAndParseMetadata(from url: URL, completion: @escaping (Metadata) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(String(describing: error))")
                return
            }
            
            let encodingName = (response as? HTTPURLResponse)?.textEncodingName ?? "utf-8"
            let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)))

            if let htmlContent = String(data: data, encoding: encoding) {
                do {
                    let doc: Document = try SwiftSoup.parse(htmlContent)
                    let title: String? = try doc.title()
                    
                    let faviconSelectors = ["link[rel='shortcut icon']", "link[rel='icon']", "link[rel='apple-touch-icon']"]
                    var faviconUrl: String? = nil
                    
                    for selector in faviconSelectors {
                        if let faviconLink: Element = try doc.select(selector).first() {
                            if var href = try? faviconLink.attr("href"), !href.isEmpty {
                                if href.starts(with: "/") {
                                    href = url.scheme! + "://" + url.host! + href
                                } else if !href.starts(with: "http") {
                                    href = url.scheme! + "://" + url.host! + "/" + href
                                }
                                faviconUrl = href
                                break
                            }
                        }
                    }
                    
                    if faviconUrl == nil {
                        faviconUrl = url.scheme! + "://" + url.host! + "/favicon.ico"
                    }

                    let decodedUrlString = url.absoluteString.removingPercentEncoding ?? url.absoluteString
                    let metadata = Metadata(title: title, faviconUrl: faviconUrl, url: decodedUrlString)

                    DispatchQueue.main.async {
                        completion(metadata)
                    }
                } catch {
                    print("Failed to parse HTML: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func getMetadata() {
//        fetchAndParseMetadata(from: url) { metadata in
//            dump(metadata)
//            let encodedTitle = metadata.title?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
//            let encodedData = metadata.url?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
//            let encodedFaviconUrl = metadata.faviconUrl?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
//            let urlString = "iBox://url?title=\(encodedTitle)&data=\(encodedData)&faviconUrl=\(encodedFaviconUrl)"
//            
//            if let openUrl = URL(string: urlString) {
//                if self.openURL(openUrl) {
//                    print("iBox 앱이 성공적으로 열렸습니다.")
//                } else {
//                    print("iBox 앱을 열 수 없습니다.")
//                }
//            }
//        }
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
