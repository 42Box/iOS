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
        case updateMyPageSectionViewModels
    }
    
    // MARK: - Properties
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    var myPageSectionViewModels = [MyPageSectionViewModel]()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewWillAppear:
                self?.myPageSectionViewModels.removeAll()
                self?.updateMyPageSectionViewModels()
                self?.output.send(.updateMyPageSectionViewModels)
            case let .setPreload(isOn):
                UserDefaultsManager.isPreload = isOn
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateMyPageSectionViewModels() {
        myPageSectionViewModels.append(MyPageSectionViewModel(cellViewModels: [
            MyPageCellViewModel(MyPageItem(type: .theme, description: UserDefaultsManager.theme.toString())),
            MyPageCellViewModel(MyPageItem(type: .homeTab, description: HomeTabType.allCases[UserDefaultsManager.homeTabIndex].toString())),
            MyPageCellViewModel(MyPageItem(type: .preload, flag: UserDefaultsManager.isPreload))
        ]))
        myPageSectionViewModels.append(MyPageSectionViewModel(cellViewModels: [
            MyPageCellViewModel(MyPageItem(type: .guide)),
            MyPageCellViewModel(MyPageItem(type: .feedback)),
            MyPageCellViewModel(MyPageItem(type: .developer))
        ]))
    }
    
}
