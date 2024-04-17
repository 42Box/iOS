//
//  SettingsViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Combine
import Foundation

class SettingsViewModel {
    
    enum Input {
        case viewWillAppear
        case setHaptics(_ isOn: Bool)
        case setPreload(_ isOn: Bool)
    }
    
    enum Output {
        case updateSectionViewModels
    }
    
    // MARK: - Properties
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    var sectionViewModels = [SettingsSectionViewModel]()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewWillAppear:
                self?.sectionViewModels.removeAll()
                self?.updateSectionViewModels()
                self?.output.send(.updateSectionViewModels)
            case let .setHaptics(isOn):
                UserDefaultsManager.isHaptics = isOn
            case let .setPreload(isOn):
                UserDefaultsManager.isPreload = isOn
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateSectionViewModels() {
        sectionViewModels.append(SettingsSectionViewModel(cellViewModels: [
            SettingsCellViewModel(SettingsItem(type: .theme, description: UserDefaultsManager.theme.toString())),
            SettingsCellViewModel(SettingsItem(type: .homeTab, description: HomeTabType.allCases[UserDefaultsManager.homeTabIndex].toString())),
            SettingsCellViewModel(SettingsItem(type: .haptics, flag: UserDefaultsManager.isHaptics)),
            SettingsCellViewModel(SettingsItem(type: .preload, flag: UserDefaultsManager.isPreload))
        ]))
        sectionViewModels.append(SettingsSectionViewModel(cellViewModels: [
            SettingsCellViewModel(SettingsItem(type: .reset)),
            SettingsCellViewModel(SettingsItem(type: .guide)),
            SettingsCellViewModel(SettingsItem(type: .feedback))
        ]))
    }
    
}
