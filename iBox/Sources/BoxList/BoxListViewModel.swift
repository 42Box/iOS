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
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func viewModel(at indexPath: IndexPath) -> BoxListCellViewModel {
        return boxList[indexPath.section].boxListCellViewModelsWithStatus[indexPath.row]
    }
    
    func deleteBookmark(at indexPath: IndexPath) {
        let bookmarkId = boxList[indexPath.section].viewModel(at: indexPath.row).id
        CoreDataManager.shared.deleteBookmark(id: bookmarkId)
        boxList[indexPath.section].deleteCell(at: indexPath.row)
        output.send(.sendBoxList(boxList: boxList))
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
