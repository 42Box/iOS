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
    var haveReloadData = false
    var isEditing = false
    
    enum Input {
        case toggleEditStatus
        case viewDidLoad
        case viewWillAppear
        case folderTapped(section: Int)
        case deleteBookmark(indexPath: IndexPath)
        case setFavorite(indexPath: IndexPath)
        case moveBookmark(from: IndexPath, to: IndexPath)
    }
    
    enum Output {
        case sendBoxList(boxList: [BoxListSectionViewModel])
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
            case .viewWillAppear:
                output.send(.sendBoxList(boxList: boxList))
            case let .folderTapped(section):
                boxList[section].isOpened.toggle()
                output.send(.sendBoxList(boxList: boxList))
            case let .deleteBookmark(indexPath):
                deleteBookmark(at: indexPath)
            case let .setFavorite(indexPath):
                print("\(viewModel(at: indexPath).name) favorite 할게용")
            case .moveBookmark(from: let from, to: let to):
                reorderBookmark(srcIndexPath: from, destIndexPath: to)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func viewModel(at indexPath: IndexPath) -> BoxListCellViewModel {
        return boxList[indexPath.section].boxListCellViewModelsWithStatus[indexPath.row]
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
        haveReloadData = true
        output.send(.sendBoxList(boxList: boxList))
    }
    
    func reorderBookmark(srcIndexPath: IndexPath, destIndexPath: IndexPath) {
        let mover = boxList[srcIndexPath.section].deleteCell(at: srcIndexPath.row)
        boxList[destIndexPath.section].insertCell(mover, at: destIndexPath.row)
        
        let destFolderId = boxList[destIndexPath.section].id
        CoreDataManager.shared.moveBookmark(from: srcIndexPath, to: destIndexPath, srcId: mover.id, destFolderId: destFolderId)
        

        //            let src = self.itemIdentifier(for: srcip)!
        //            var snap = self.snapshot()
        //            if let dest = self.itemIdentifier(for: destip) {
        //
        //            if snap.indexOfItem(src)! > snap.indexOfItem(dest)! {
        //                snap.moveItem(src, beforeItem:dest)
        //            } else {
        //                snap.moveItem(src, afterItem:dest)
        //            }
        //        } else {
        //            snap.deleteItems([src])
        //            snap.appendItems([src], toSection: snap.sectionIdentifiers[destip.section])
        //        }
        //        self.apply(snap, animatingDifferences: false)
                
    }
    
    func addFolder(_ folder: Folder) {
        let boxListSectionViewModel = BoxListSectionViewModel(folder: folder)
        boxList.append(boxListSectionViewModel)
        haveReloadData = true
    }
    
    func deleteFolder(at row: Int) {
        boxList.remove(at: row)
        haveReloadData = true
    }
    
    func editFolderName(at row: Int, name: String) {
        boxList[row].name = name
        haveReloadData = true
    }
    
    func moveFolder(from: Int, to: Int) {
        let mover = boxList.remove(at: from)
        boxList.insert(mover, at: to)
        haveReloadData = true
    }

}
