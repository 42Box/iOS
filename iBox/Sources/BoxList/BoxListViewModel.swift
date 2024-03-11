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
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case folderTapped(section: Int)
    }
    
    enum Output {
        case sendBoxList(boxList: [BoxListSectionViewModel])
    }
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                let folders = CoreDataManager.shared.getFolders()
                self.boxList = folders.map{ BoxListSectionViewModel(folder: $0) }
            case .viewWillAppear:
                output.send(.sendBoxList(boxList: boxList))
            case let .folderTapped(section):
                boxList[section].isOpened.toggle()
                output.send(.sendBoxList(boxList: boxList))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func viewModel(at indexPath: IndexPath) -> BoxListCellViewModel {
        return boxList[indexPath.section].boxListCellViewModels[indexPath.row]
    }
    
    func addFolder(_ folder: Folder) {
        let boxListSectionViewModel = BoxListSectionViewModel(folder: folder)
        boxList.append(boxListSectionViewModel)
    }

}
