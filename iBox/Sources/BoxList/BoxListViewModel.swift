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
    
    enum Input {
        case viewDidLoad
        case folderTapped(section: Int)
        case deleteBookmark(indexPath: IndexPath)
        case setFavorite(indexPath: IndexPath)
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
                output.send(.sendBoxList(boxList: boxList))
            case let .folderTapped(section):
                boxList[section].isOpened.toggle()
                output.send(.sendBoxList(boxList: boxList))
            case let .deleteBookmark(indexPath):
                print("\(viewModel(at: indexPath).name) 지울게용")
            case let .setFavorite(indexPath):
                print("\(viewModel(at: indexPath).name) favorite 할게용")
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func viewModel(at indexPath: IndexPath) -> BoxListCellViewModel {
        return boxList[indexPath.section].boxListCellViewModels[indexPath.row]
    }

}
