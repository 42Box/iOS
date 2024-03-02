//
//  MyPageViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Combine
import Foundation

class MyPageViewModel {
    
    enum Input {
        case viewWillAppear
        case setPreload(_ isOn: Bool)
    }
    
    enum Output {
        case updateSectionViewModels
    }
    
    // MARK: - Properties
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    var sectionViewModels = [MyPageSectionViewModel]()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewWillAppear:
                self?.sectionViewModels.removeAll()
                self?.updateSectionViewModels()
                self?.output.send(.updateSectionViewModels)
            case let .setPreload(isOn):
                UserDefaultsManager.isPreload = isOn
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateSectionViewModels() {
        sectionViewModels.append(MyPageSectionViewModel(cellViewModels: [
            MyPageCellViewModel(MyPageItem(type: .theme, description: UserDefaultsManager.theme.toString())),
            MyPageCellViewModel(MyPageItem(type: .homeTab, description: HomeTabType.allCases[UserDefaultsManager.homeTabIndex].toString())),
            MyPageCellViewModel(MyPageItem(type: .preload, flag: UserDefaultsManager.isPreload))
        ]))
        sectionViewModels.append(MyPageSectionViewModel(cellViewModels: [
            MyPageCellViewModel(MyPageItem(type: .guide)),
            MyPageCellViewModel(MyPageItem(type: .feedback)),
            MyPageCellViewModel(MyPageItem(type: .developer))
        ]))
    }
    
}
