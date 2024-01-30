//
//  BoxListViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Combine
import Foundation

class BoxListViewModel {
    
    var boxList = [
    BoxListSectionViewModel(folder: Folder(name: "기본 폴더", color: .gray, bookmarks: [
        Bookmark(name: "42 Intra", url: "https://profile.intra.42.fr/"),
        Bookmark(name: "42Where", url: "https://www.where42.kr/"),
        Bookmark(name: "42Stat", url: "https://stat.42seoul.kr/"),
        Bookmark(name: "집현전", url: "https://42library.kr/")
    ])),
    BoxListSectionViewModel(folder: Folder(name: "새 폴더", color: .green, bookmarks: [Bookmark(name: "Cabi", url: "https://cabi.42seoul.io/")], isOpened: false)),
    BoxListSectionViewModel(folder: Folder(name: "새 폴더(2)", color: .yellow, bookmarks: [Bookmark(name: "24HANE", url: "https://24hoursarenotenough.42seoul.kr/")], isOpened: false))
    ]
    
    enum Input {
        case viewDidLoad
        case folderTapped(section: Int)
    }
    
    enum Output {
        case toggleFolder
    }
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                print("viewDidLoad")
            case let .folderTapped(section):
                self?.toggleFolder(section: section)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func viewModel(at indexPath: IndexPath) -> BoxListCellViewModel {
        return boxList[indexPath.section].boxListCellViewModels[indexPath.row]
    }
    
    func toggleFolder(section: Int) {
        
        boxList[section].isOpen.toggle()
        output.send(.toggleFolder)
    }

}
