//
//  BoxListViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Combine
import Foundation

class BoxListViewModel {
    
    var boxList = [BoxListSectionViewModel]()
    
    var folders: [Folder] {
        boxList.map{ $0.folder }
    }

    var sectionsToReload = Set<BoxListSectionViewModel.ID>()
    var isEditing = false
    var favoriteId: UUID? = nil

    
    enum Input {
        case toggleEditStatus
        case viewDidLoad
        case viewWillAppear
        case folderTapped(section: Int)
        case deleteBookmark(indexPath: IndexPath)
        case toggleFavorite(indexPath: IndexPath)
        case moveBookmark(from: IndexPath, to: IndexPath)
        case openFolderIfNeeded(folderIndex: Int)
    }
    
    enum Output {
        case sendBoxList(boxList: [BoxListSectionViewModel])
        case reloadSections(idArray: [BoxListSectionViewModel.ID])
        case reloadRows(idArray: [BoxListCellViewModel.ID])
        case editStatus(isEditing: Bool)
    }
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .toggleEditStatus:
                isEditing.toggle()
                output.send(.editStatus(isEditing: isEditing))
            case .viewDidLoad:
                let folders = CoreDataManager.shared.getFolders()
                boxList = folders.map{ BoxListSectionViewModel(folder: $0) }
                favoriteId = UserDefaultsManager.favoriteId
            case .viewWillAppear:
                output.send(.sendBoxList(boxList: boxList))
                if !sectionsToReload.isEmpty {
                    output.send(.reloadSections(idArray: Array(sectionsToReload)))
                    sectionsToReload.removeAll()
                }
            case let .folderTapped(section):
                boxList[section].isOpened.toggle()
                output.send(.sendBoxList(boxList: boxList))
            case let .deleteBookmark(indexPath):
                deleteBookmark(at: indexPath)
            case let .toggleFavorite(indexPath):
                toggleFavorite(at: indexPath)
            case .moveBookmark(from: let from, to: let to):
                reorderBookmark(srcIndexPath: from, destIndexPath: to)
            case .openFolderIfNeeded(folderIndex: let folderIndex):
                openFolder(folderIndex)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func viewModel(at indexPath: IndexPath) -> BoxListCellViewModel {
        return boxList[indexPath.section].boxListCellViewModels[indexPath.row]
    }
    
    func isFavoriteBookmark(at indexPath: IndexPath) -> Bool {
        if let favoriteId {
            if favoriteId == bookmark(at: indexPath).id {
                return true
            } else { return false }
        } else {
            return false
        }
    }
    
    private func toggleFavorite(at indexPath: IndexPath) {
        let bookmark = boxList[indexPath.section].viewModel(at: indexPath.row)
        if let prevId = favoriteId {
            if prevId == bookmark.id { // 지금 들어온게 즐겨찾기면 지워야
                WebViewPreloader.shared.setFavoriteUrl(url: nil)
                favoriteId = nil
                UserDefaultsManager.favoriteId = nil
            } else {
                WebViewPreloader.shared.setFavoriteUrl(url: bookmark.url)
                favoriteId = bookmark.id
            }
        } else {
            WebViewPreloader.shared.setFavoriteUrl(url: bookmark.url)
            favoriteId = bookmark.id
        }
        UserDefaultsManager.favoriteId = favoriteId
    }
    
    func bookmark(at indexPath: IndexPath) -> Bookmark {
        return boxList[indexPath.section].viewModel(at: indexPath.row).bookmark
    }
    
    func deleteBookmark(at indexPath: IndexPath) {
        let bookmarkId = boxList[indexPath.section].viewModel(at: indexPath.row).id
        CoreDataManager.shared.deleteBookmark(id: bookmarkId)
        boxList[indexPath.section].deleteCell(at: indexPath.row)
        output.send(.sendBoxList(boxList: boxList))
    }
    
    func editBookmark(at indexPath: IndexPath, name: String, url: URL) {
        let bookmarkId = boxList[indexPath.section].viewModel(at: indexPath.row).id
        CoreDataManager.shared.updateBookmark(id: bookmarkId, name: name, url: url)
        boxList[indexPath.section].updateCell(at: indexPath.row, bookmark: Bookmark(id: bookmarkId, name: name, url: url))
        output.send(.reloadRows(idArray: [bookmarkId]))
    }
    
    func reorderBookmark(srcIndexPath: IndexPath, destIndexPath: IndexPath) {
        let mover = boxList[srcIndexPath.section].deleteCell(at: srcIndexPath.row)
        boxList[destIndexPath.section].insertCell(mover, at: destIndexPath.row)
        
        let destFolderId = boxList[destIndexPath.section].id
        CoreDataManager.shared.moveBookmark(from: srcIndexPath, to: destIndexPath, srcId: mover.id, destFolderId: destFolderId)
    }
    
    func openFolder(_ folderIndex: Int) {
        let destFolderId = boxList[folderIndex].id
        if boxList[folderIndex].openSectionIfNeeded() {
            output.send(.reloadSections(idArray: [destFolderId]))
            output.send(.sendBoxList(boxList: boxList))
        }
    }
    
    func addFolder(_ folder: Folder) {
        let boxListSectionViewModel = BoxListSectionViewModel(folder: folder)
        boxList.append(boxListSectionViewModel)
    }
    
    func deleteFolder(at row: Int) {
        sectionsToReload.remove(boxList[row].id)
        boxList.remove(at: row)
    }
    
    func editFolderName(at row: Int, name: String) {
        boxList[row].name = name
        sectionsToReload.update(with: boxList[row].id)
    }
    
    func moveFolder(from: Int, to: Int) {
        let mover = boxList.remove(at: from)
        boxList.insert(mover, at: to)
        for box in boxList {
            sectionsToReload.update(with: box.id)
        }
    }
    
    func addFolderDirect(_ folder: Folder) {
        let boxListSectionViewModel = BoxListSectionViewModel(folder: folder)
        boxList.append(boxListSectionViewModel)
        output.send(.sendBoxList(boxList: boxList))
    }
    
    func addBookmarkDirect(_ bookmark: Bookmark, at index: Int) {
        boxList[index].boxListCellViewModels.append(BoxListCellViewModel(bookmark: bookmark))
        output.send(.sendBoxList(boxList: boxList))
    }
    
    func addFolderDirect(_ folder: Folder) {
        let boxListSectionViewModel = BoxListSectionViewModel(folder: folder)
        boxList.append(boxListSectionViewModel)
        output.send(.sendBoxList(boxList: boxList))
    }
    
    func addBookmarkDirect(_ bookmark: Bookmark, at index: Int) {
        boxList[index].boxListCellViewModels.append(BoxListCellViewModel(bookmark: bookmark))
        output.send(.sendBoxList(boxList: boxList))
    }

}
