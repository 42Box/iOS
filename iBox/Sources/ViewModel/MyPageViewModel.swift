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
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateMyPageSectionViewModels() {
        myPageSectionViewModels.append(MyPageSectionViewModel(
            MyPageSection(
                title: "settings",
                items: [
                    MyPageItem(title: "테마", description: UserDefaultsManager.theme.toString()),
                    MyPageItem(title: "홈화면", description: HomeTabType.allCases[UserDefaultsManager.homeTabIndex].toString())
                ]
            )
        ))
        myPageSectionViewModels.append(MyPageSectionViewModel(
            MyPageSection(
                title: "help",
                items: [
                    MyPageItem(title: "이용 가이드"),
                    MyPageItem(title: "앱 피드백"),
                    MyPageItem(title: "개발자 정보")
                ]
            ))
        )
    }
    
}
